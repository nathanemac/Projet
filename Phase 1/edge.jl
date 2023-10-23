"""
Type abstrait dont d'autres types d'arêtes dériveront.
"""
abstract type AbstractEdge{T, U} end

"""
Type représentant les arêtes d'un graphe.

Exemple:

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    edge = Edge(node1, node2)       # Arête non pondérée
    edge = Edge(node1, node2, 5.6)  # Arête pondérée avec un poids de 5.6
"""
mutable struct Edge{T, U} <: AbstractEdge{T, U}
  start_node::Node{T}
  end_node::Node{T}
  weight::U
end

# Constructeur pour les arêtes non pondérées
Edge(s::Node{T}, e::Node{T}) where T = Edge(s, e, nothing)

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `start_node`, `end_node` et `weight`.

"""Renvoie le noeud de départ de l'arête."""
start_node(edge::AbstractEdge) = edge.start_node

"""Renvoie le noeud d'arrivée de l'arête."""
end_node(edge::AbstractEdge) = edge.end_node

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
    if edge.weight === nothing
        println("Edge from ", name(start_node(edge)), " to ", name(end_node(edge)))
    else
        println("Edge from ", name(start_node(edge)), " to ", name(end_node(edge)), ", weight: ", weight(edge))
    end
end  

# Définir un nouveau type `ExtendedGraph`
mutable struct ExtendedGraph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T}}
end

# Constructeur pour ExtendedGraph
ExtendedGraph(name::String, nodes::Vector{Node{T}}) where T = ExtendedGraph(name, nodes, Edge{T}[])

# Fonction pour ajouter un noeud à un AbstractGraph : 
"""Ajoute un noeud à un ExtendedGraph"""
function add_node!(graph::AbstractGraph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

# Fonction pour ajouter une arête à ExtendedGraph
"""Ajoute une arête à un ExtendedGraph"""
function add_edge!(graph::ExtendedGraph{T}, start_node::Node{T}, end_node::Node{T}, weight = nothing) where {T}
  # Vérifier si les nœuds existent déjà dans le graphe
  if start_node ∉ graph.nodes || end_node ∉ graph.nodes
      throw(ArgumentError("One or both nodes are not part of the graph"))
  end

  # Créer la nouvelle arête
  new_edge = Edge(start_node, end_node, weight)
  
  # Vérifier si l'arête existe déjà
  for edge in graph.edges
      if (edge.start_node == start_node && edge.end_node == end_node) || 
         (edge.start_node == end_node && edge.end_node == start_node)
         return  # simplement retourner si l'arête existe déjà, évitant une erreur

      end
  end

  # Ajouter la nouvelle arête au graphe
  push!(graph.edges, new_edge)
end

# Affichage de ExtendedGraph
"""Extension de la fonction `show`pour un ExtendedGraph"""
function show(graph::ExtendedGraph{T}) where {T}
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes and ", length(graph.edges), " edges.")
  println("Nodes:")
  for node in nodes(graph)
      show(node)
  end
  println("Edges:")
  for edge in graph.edges
      show(edge)
  end
end

"""Analyse un fichier .tsp et renvoie l'ensemble des arêtes sous la forme d'un tableau."""
function read_edges(header::Dict{String, String}, filename::String)

  edges = []
  edge_weight_format = header["EDGE_WEIGHT_FORMAT"]
  known_edge_weight_formats = ["FULL_MATRIX", "UPPER_ROW", "LOWER_ROW",
  "UPPER_DIAG_ROW", "LOWER_DIAG_ROW", "UPPER_COL", "LOWER_COL",
  "UPPER_DIAG_COL", "LOWER_DIAG_COL"]

  if !(edge_weight_format in known_edge_weight_formats)
      @warn "unknown edge weight format" edge_weight_format
      return edges, edge_weights
  end

  file = open(filename, "r")
  dim = parse(Int, header["DIMENSION"])
  edge_weight_section = false
  k = 0
  n_edges = 0
  i = 0
  n_to_read = n_nodes_to_read(edge_weight_format, k, dim)
  flag = false

  for line in eachline(file)
      line = strip(line)
      if !flag
          if occursin(r"^EDGE_WEIGHT_SECTION", line)
              edge_weight_section = true
              continue
          end

          if edge_weight_section
              data = split(line)
              n_data = length(data)
              start = 0
              while n_data > 0
                  n_on_this_line = min(n_to_read, n_data)

                  for j = start : start + n_on_this_line - 1
                    # Les lignes suivantes ont été modifiées pour tenir compte du poids des arêtes
                    n_edges = n_edges + 1
                    edge_weight_value = parse(Float64, data[start+j+1])
                    if edge_weight_format in ["UPPER_ROW", "LOWER_COL"]
                      edge = (k+1, i+k+2, edge_weight_value)
                    elseif edge_weight_format in ["UPPER_DIAG_ROW", "LOWER_DIAG_COL"]
                      edge = (k+1, i+k+1, edge_weight_value)
                    elseif edge_weight_format in ["UPPER_COL", "LOWER_ROW"]
                      edge = (i+k+2, k+1, edge_weight_value)
                    elseif edge_weight_format in ["UPPER_DIAG_COL", "LOWER_DIAG_ROW"]
                      edge = (i+1, k+1, edge_weight_value)
                    elseif edge_weight_format == "FULL_MATRIX"
                      edge = (k+1, i+1, edge_weight_value)
                    else
                      warn("Unknown format - function read_edges")
                    end
                    push!(edges, edge)
                    i += 1
                  end

                  n_to_read -= n_on_this_line
                  n_data -= n_on_this_line

                  if n_to_read <= 0
                      start += n_on_this_line
                      k += 1
                      i = 0
                      n_to_read = n_nodes_to_read(edge_weight_format, k, dim)
                  end

                  if k >= dim
                      n_data = 0
                      flag = true
                  end
              end
          end
      end
  end
  close(file)
  return edges
end

"""
Structure contenant les composantes connexes d'un graphe.

Exemple:
    TODO
"""
mutable struct ConnexGraph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{ConnexNode{T}}
  edges::Vector{Edge{T}}
end

# Constructeur pour ExtendedGraph
ConnexGraph(name::String, nodes::Vector{Node{T}}) where T = ConnexGraph(name, nodes, Edge{T}[])

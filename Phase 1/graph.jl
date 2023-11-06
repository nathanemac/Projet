import Base.show

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    G = Graph("Ick", [node1, node2, node3])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
end

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end


"""Construit un graphe à partir d'une instance TSP symétrique dont les poids sont donnés au format EXPLICIT et renvoie l'objet Graph associé"""
function build_graph(instance::String, title::String)
  
  header = read_header(instance)
  if header["EDGE_WEIGHT_TYPE"] != "EXPLICIT"
    @warn "weight type format must be EXPLICIT"
    return "Current format is :", header["EDGE_WEIGHT_TYPE"]
  end
  if header["EDGE_WEIGHT_FORMAT"] != "FULL_MATRIX"
    @warn "edge weight format must be FULL_MATRIX"
    return "Current format is :", header["EDGE_WEIGHT_FORMAT"]
  end

  nodes_graph = read_nodes(header, instance)
  edges_graph = read_edges(header, instance)

  if isempty(nodes_graph)
    for i = 1:parse(Int64, header["DIMENSION"])
      dict_intermediaire = Dict(i => [])
      merge!(nodes_graph, dict_intermediaire)
    end
  end


  graph_built = ExtendedGraph(title, [Node("1", nodes_graph[1])])
  for i=2:length(nodes_graph)
    node = Node(string(i), nodes_graph[i])
    add_node!(graph_built, node)
  end

  for i=1:length(edges_graph)
    s_node = graph_built.nodes[edges_graph[i][1]]
    e_node = graph_built.nodes[edges_graph[i][2]]
    w_edge = edges_graph[i][3]
    add_edge!(graph_built, s_node, e_node, w_edge)
  end
  graph_built
end

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
nodes(graph::AbstractGraph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::AbstractGraph) = length(graph.nodes)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  for node in nodes(graph)
    show(node)
  end
end

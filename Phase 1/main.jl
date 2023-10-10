include("node.jl")
include("graph.jl")
include("read_stsp.jl")
include("edge.jl")



"""Construit un graphe à partir d'une instance TSP symétrique dont les poids sont donnés au format EXPLICIT et renvoie l'objet Graph associé"""
#  Arguments
# - `instance::String` : Le chemin vers le fichier TSP contenant les données de l'instance.
# - `title::String` : Le titre du graphe construit.
# Examples
```
julia> build_graph("instances/stsp/bays29.tsp", "Graph_Test")

Graph Graph_Test has 29 nodes and 435 edges.
Nodes:
Node 1, data: [1150.0, 1760.0]
Node 2, data: [630.0, 1660.0]
# ... (d'autres nœuds et arêtes)
Edge from 28 to 29, weight: 199.0
Edge from 29 to 29, weight: 0.0
```

function build_graph(instance::String, title::String)
  
  header = read_header(instance)
  if header["EDGE_WEIGHT_TYPE"] != "EXPLICIT"
    @warn "weight type format must be `EXPLICIT`"
    return "Current format is :", header["EDGE_WEIGHT_TYPE"]
  end
  if header["EDGE_WEIGHT_FORMAT"] != "FULL_MATRIX"
    @warn "edge weight format must be `FULL_MATRIX`"
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
  show(graph_built)
end


# Exemple d'utilisation du fichier main : 
# build_graph("Phase 1/instances/stsp/bays29.tsp", "Graph_Test")

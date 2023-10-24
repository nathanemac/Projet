include("../Phase 1/edge.jl")
include("../Phase 1/node.jl")
include("../Phase 1/graph.jl")
include("../Phase 1/read_stsp.jl")
include("../Phase 1/main.jl")
include("../Phase 1/utils.jl")

n1 = Node("1", [1.0, 3.0], nothing)
n2 = Node("2", [2.0, 0.0, 1.0])
n3 = Node("3", [1.0, 2.0], nothing)
n4 = Node("4", [1.0, 2.0])
n5 = Node("5", [2.0, 3.9])

e1 = Edge(n1, n2, 5.6)
e2 = Edge(n2, n3, 1.0)
e3 = Edge(n1, n3, 2.0)
e4 = Edge(n2, n4, 2.0)
e5 = Edge(n1, n4, 0.5)
e6 = Edge(n4, n5, 3.0)


G = ExtendedGraph("test", [n1, n2, n3, n4, n5], [e1, e2, e3, e4, e5, e6])


connexcomp1 = ConnexComponent("connex component 1", [n1, n2])
connexcomp2 = ConnexComponent("connex component 2", [n3, n4])
connexcomp3 = ConnexComponent("connex component 3", [n5])


graph_test = ConnexGraph("graph test", [connexcomp1, connexcomp2])


##############################

# Questions 1, 2
graph = build_graph("Phase 1/instances/stsp/bays29.tsp", "Graph_Test")
mst_graph = Kruskal(graph)


# Question 3

# Ajout de l'attribut "rang"
n1 = Node("n1", [1.0, 2.0], nothing, 0)
n2 = Node("n2", [2.0, 3.0], nothing, 0)

# Union via le rang : 

union!([n1, n2])
find_root!(n2) # Le parent de n2 est à présent n1

# Exemple sur davantage de noeuds : 
CC = ConnexComponent("ex", [Node("1", 0.5)])
for i = 2:10
  push!(CC.nodes, Node("n$i", rand(1)[1]))
end
CC.nodes

union!(CC.nodes) # le premier noeud sert de racine, les 9 autres sont des enfants directs du noeud 1


# TODO : répondre question sur le rang

##########
# Question 4

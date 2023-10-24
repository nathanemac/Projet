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
graph = build_graph("Phase 1/instances/stsp/bays29.tsp", "Graph_Test")
mst_graph = Kruskal(graph)



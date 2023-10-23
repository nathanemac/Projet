include("../Phase 1/node.jl")
include("../Phase 1/graph.jl")
include("../Phase 1/read_stsp.jl")
include("../Phase 1/edge.jl")

n1 = ConnexNode("noeud 1", [1.0, 3.0], nothing)
n2 = ConnexNode("noeud 2", [2.0, 0.0, 1.0], n1)
n3 = ConnexNode("noeud 3", [1.0, 2.0], nothing)
n4 = ConnexNode("noeud 4", [1.0, 2.0], n3)
n5 = ConnexNode("noeud 5", [1.0, 2.0], n3)

connexcomp1 = ConnexComponent("connex component 1", [n1, n2])
connexcomp2 = ConnexComponent("connex component 2", [n3, n4, n5])

graph = ConnexGraph("graph test", [connexcomp1, connexcomp2])

connexcomp1.nodes[2].parents
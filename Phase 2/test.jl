include("../Phase 1/node.jl")
include("../Phase 1/graph.jl")
include("../Phase 1/read_stsp.jl")
include("../Phase 1/edge.jl")

n1 = ConnexNode(1, [1.0, 3.0], nothing)
n2 = ConnexNode(2, [2.0, 0.0, 1.0], n1)
n3 = ConnexNode(3, [1.0, 2.0], nothing)
n4 = ConnexNode(4, [1.0, 2.0], n3)
n5 = ConnexNode(5, [1.0, 2.0], n3)

connexcomp1 = ConnexComponent("connex component 1", [n1, n2])
connexcomp2 = ConnexComponent("connex component 2", [n3, n4, n5])

graph = ConnexGraph("graph test", [connexcomp1, connexcomp2])

parent(connexcomp1.nodes[2])

function Kruskal(graph::ExtendedGraph)
  A = []
  k = 0
  S = graph.nodes
  

end


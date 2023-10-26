include("../Phase 1/node.jl")
include("../Phase 1/edge.jl")
include("../Phase 1/graph.jl")
include("../Phase 1/read_stsp.jl")
include("../Phase 1/main.jl")
include("utils.jl")
include("PriorityQueue.jl")

n1 = Node("1", [1.0, 3.0], nothing)
n2 = Node("2", [2.0, 1.0])
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

# Exemple sur deux composantes connexes de même rang maximal : 
CC1 = ConnexComponent("cc1", [Node("1", 0.5)])
for i = 2:10
  push!(CC1.nodes, Node("n$i", rand(1)[1]))
end
CC2 = ConnexComponent("cc2", [Node("11", 0.8)])
for i = 2:10
  push!(CC2.nodes, Node("n$(i+10)", rand(1)[1]))
end


union_all!(CC1, CC2)

CC3 = ConnexComponent("cc3", [Node("21", 1.5)])
for i = 2:5
  push!(CC3.nodes, Node("n$(i+20)", rand(1)[1]))
end

union_all!(CC1, CC3)
# TODO : répondre question sur le rang
# sinon ça m'a l'air ok, à tester. 

##########
# Question 4


function Prim(graph::ExtendedGraph, st_node::AbstractNode)

  # Initialisation du graphe résultant
  graph_res = ExtendedGraph("res", Vector{typeof(st_node)}())

  N = graph.nodes
  E = graph.edges

  # On recherche st_node dans le graphe donné
  idx = findfirst(x -> x == st_node, N)
  if idx === nothing
    @warn "starting node not in graph"
    return
  end

  # Création de la file de priorité pour traiter les noeuds
  q = PriorityQueue([PriorityItem(Inf, n) for n in N])
  priority!(q.items[idx], 0)


  # Boucle principale :
  while !isempty(q.items)
    # On choisit le noeud avec la priorité la plus faible (l'arête la plus légère)
    # Pour la première itération, st_node est le noeud avec la plus faible priorité
    u = pop_lowest!(q)
    add_node!(graph_res, u.data)
    neighbours = neighbours_node(u.data, graph)
    # la ligne suivante extrait la liste des noeuds voisins de u.data. Le noeud à considérer comme prioritaire est le premier de cette liste. 
    neighbours = [edge.start_node === u.data ? edge.end_node : edge.start_node for edge in neighbours_node(u.data, graph)]

    # la ligne suivante extrait la liste des noeuds voisins de u.data. 
    neighbours = [edge.start_node === u.data ? edge.end_node : edge.start_node for edge in neighbours_node(u.data, graph)]

    # Chercher le premier voisin qui est encore dans q.items
    i = 1
    while i <= length(neighbours)
      idx = findfirst(item -> item.data == neighbours[i], q.items)
      if idx !== nothing
        # on modifie la priorité du noeud à considérer pour l'ajouter au graphe à la prochaine itération
        priority!(q.items[idx], 0)
        q.items[idx].data.parent = graph_res.nodes[end]
        break
      else
        i += 1
      end
    end
  end
  graph_res.nodes[end].parent = graph_res.nodes[end-1] # Lie l'avant dernier noeud avec le dernier


  return graph_res
end

"""Retourne l'ensemble des arêtes de graph contenant n, triées par ordre croissant de poids"""
function neighbours_node(n::AbstractNode, graph::ExtendedGraph)
  E = graph.edges
  neighbours = [] # vecteur qui contiendra les arêtes voisines

  for e in E
    if e.start_node == n || e.end_node == n # si n appartient à l'arête e
      push!(neighbours, e)
    end
  end
  return sort(neighbours, by=edge -> edge.weight)
end






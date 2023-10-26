###############################
#### Algorithme de Kruskal ####
###############################

function find_component(Components, node)
  # Trouve et renvoie la composante connexe à laquelle appartient le noeud donné
  for component in Components
      if node in component.nodes
          return component
      end
  end
  return nothing
end

function merge_components!(components, component1, component2)
  # Fusionne deux composantes connexes en une seule et supprime l'ancienne composante
  for node in component2.nodes
      push!(component1.nodes, node)
  end
  deleteat!(components, findfirst(x -> x == component2, components))
end


function Kruskal(graph::ExtendedGraph)
  A0 = typeof(graph.edges[1])[]
  A = graph.edges
  S_connex = ConnexGraph("Graphe connexe", graph)
  S = graph.nodes

  res = ExtendedGraph("res Kruskal", S, A0)

  # Chaque sommet du graphe est ajouté comme ConnexComponent à un ConnexGraph initialement vide
  for n in S
    add_connex_component!(S_connex, ConnexComponent("", [n]))
  end

  # Tri des arêtes par ordre croissant des poids
  A_sorted = sort(A, by = e -> e.weight)
  Components = S_connex.components
  
  # Traitement des arêtes
  for a in A_sorted
    # Pour chaque arête, on détermine les composantes connexes auxquelles appartiennent les sommets de départ et d'arrivée
    start_component = find_component(Components, a.start_node)
    end_component = find_component(Components, a.end_node)

    # Si les deux sommets ne font pas partie de la même composante connexe
    if start_component !== end_component
        # Ajoutez l'arête à A0
        push!(A0, a)
        
        # Fusionne les deux composantes connexes
        merge_components!(Components, start_component, end_component)
    end
  end
  return res
end

#################################
#### Pour les 2 heuristiques ####
#################################

function find_root!(CC::ConnexComponent)

  # Renvoie la racine de la composante si elle n'est pas déjà déterminée
  if CC.root !== nothing
    return CC.root
  end

  root = CC.nodes[1]
  for node in CC.nodes
    # On s'arrête dès que l'on trouve un noeud sans parent
    if node.parent === nothing
      root = node
      root.rank += 1
      CC.root = root
      break
    end
  end
  
  # On fait pointer les nœuds directement vers la racine.
  for node in CC.nodes
    if node === root
      continue
    else
      node.parent = root
    end
  end
  root
end

function union_roots!(root1::AbstractNode, root2::AbstractNode)

  # Lie la racine de rang inférieur à la racine de rang supérieur
  if root1.rank > root2.rank
      root2.parent = root1
  elseif root1.rank < root2.rank
      root1.parent = root2
  else
      # Si les deux racines ont le même rang, lie l'une à l'autre et augmentez le rang de la racine parent
      root2.parent = root1
      root1.rank += 1
  end
  return
end

function union_all!(CC1::ConnexComponent, CC2::ConnexComponent)
  # Trouver les racines des deux composantes
  root1 = find_root!(CC1)
  root2 = find_root!(CC2)

  # Si les racines sont déjà les mêmes, rien à faire
  if root1 === root2
      return
  end

  # Sinon, unir les deux racines
  union_roots!(root1, root2)

  # Ajoute les noeuds de la composante fille aux noeuds de la composante mère
  if root1.rank > root2.rank
    append!(CC1.nodes, CC2.nodes)
    empty!(CC2.nodes)
    return CC1.nodes
  else 
    append!(CC2.nodes, CC1.nodes)
    empty!(CC2.nodes)
    return CC2.nodes
  end
end


############################
#### Algorithme de Prim ####
############################

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

"""Implémente l'algorithme de Prim pour un graph::ExtendedGraph et un noeud du graphe"""
function Prim(graph::ExtendedGraph, st_node::AbstractNode)

  N = graph.nodes
  E = graph.edges
  # Initialisation du graphe résultant
  graph_res = ExtendedGraph("res Prim", N, Edge{Vector{Float64}, Float64}[])


  # On recherche st_node dans le graphe donné
  idx = findfirst(x -> x == st_node, N)
  if idx === nothing
    @warn "starting node not in graph"
    return
  end

  # Création de la file de priorité pour traiter les noeuds
  q = PriorityQueue([PriorityItem(Inf, n) for n in N])
  priority!(q.items[idx], 0)
  visited = Set{AbstractNode}() # Set pour vérifier les noeuds visités

  # Boucle principale :
  while !isempty(q.items)
    # On choisit le noeud avec la priorité la plus faible (l'arête la plus légère)
    u = pop_lowest!(q)
    push!(visited, u.data)

    if u.data.parent !== nothing
      # Trouver l'arête entre u et son parent et l'ajouter au graph_res
      edge_idx = findfirst(e -> (e.start_node == u.data && e.end_node == u.data.parent) || (e.start_node == u.data.parent && e.end_node == u.data), E)
      edge = E[edge_idx]
      push!(graph_res.edges, edge)
    end

    neighbours = neighbours_node(u.data, graph)

    for edge in neighbours
      v = edge.start_node === u.data ? edge.end_node : edge.start_node
      if !(v in visited) && edge.weight < get_priority(q, v)
        v.parent = u.data
        update_priority!(q, v, edge.weight)
      end
    end
  end

  return graph_res
end




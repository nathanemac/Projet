###########################
# Pour Kruskal 

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

  return A0
end

#############################
# Pour les 2 heuristiques 
function find_root!(node::Node)
  if node.parent === nothing
      return node
  end
  node.parent = find_root!(node.parent)
  return node.parent
end

# Trouver le représentant (racine) d'un nœud avec compression de chemin
function find_root!(node::Node)
  if node.parent == nothing
      return node
  else
      # Compression de chemin
      node.parent = find_root!(node.parent)
      return node.parent
  end
end

# Union d'un vecteur de nœuds en utilisant le rang
function union!(nodes::Vector{Node})
  # Assurez-vous que le vecteur n'est pas vide
  if isempty(nodes)
      return
  end

  # Trouvez les racines de tous les nœuds
  roots = [find_root!(node) for node in nodes]

  # Triez les racines par rang (en ordre décroissant)
  sort!(roots, by=n -> n.rank, rev=true)

  # Pour chaque racine, sauf la première, faites de la première racine son parent.
  # Si deux racines ont le même rang, augmentez le rang de la première racine.
  for i in 2:length(roots)
      if roots[1].rank == roots[i].rank
          roots[1].rank += 1
      end
      roots[i].parent = roots[1]
  end
end



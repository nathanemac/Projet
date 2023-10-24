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
        
        # Fusionnez les deux composantes connexes
        merge_components!(Components, start_component, end_component)
    end
  end

  return A0
end
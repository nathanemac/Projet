import Base.show
import Base.push!

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""
Type représentant les noeuds d'un graphe.

Exemple:

        noeud1 = Node("James", [π, exp(1)])
        noeud2 = Node("Kirk", "guitar")
        noeud3 = Node("Lars", 2, noeud1)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  parent::Union{Node{T}, Nothing}
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie le parent d'un noeud."""
function parent(node::AbstractNode)
  if node.parent == nothing
    return "No parent for node"
  else 
    return node.parent
  end
end

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node), ", parent: ", parent(node))
end

#################################
########### Phase 2 #############
#################################
# Constructeur pour un Node avec parent :
Node(name::String, data::T, parent::Union{Node{T}, Nothing}) where T = Node{T}(name, data, parent)

# Constructeur pour un Node sans parent :
Node(name::String, data::T) where T = Node{T}(name, data, nothing)

function add_connex_component!(g::ConnexGraph{T}, c::ConnexComponent{T}) where T
  push!(g.components, c)
end
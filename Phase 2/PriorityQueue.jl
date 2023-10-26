import Base.isless, Base.==, Base.popfirst!

"""Structure implémentant un item de priorité dont tous les types d'items de priorité découleront"""
abstract type AbstractPriorityItem{T} end

"""Type implémentant un item de priorité"""
mutable struct PriorityItem{T} <: AbstractPriorityItem{T}
  priority::Number
  data::T
end

"""Constructeur de PriorityItem"""
function PriorityItem(priority::Number, data::T) where T
  PriorityItem{T}(max(0, priority), data)
end

"""Renvoie la priorité d'un PriorityItem"""
priority(p::PriorityItem) = p.priority

"""Modifie la valeur de la priorité d'un PriorityItem"""
function priority!(p::PriorityItem, priority::Number)
  p.priority = max(0, priority)
  p
end

isless(p::PriorityItem, q::PriorityItem) = priority(p) < priority(q)
==(p::PriorityItem, q::PriorityItem) = priority(p) == priority(q)

"""Type abstrait d'une file dont tous les types concrets découleront"""
abstract type AbstractQueue{T} end

"""Structure implémentant une file de priorité."""
mutable struct PriorityQueue{T <: AbstractPriorityItem} <: AbstractQueue{T}
  items::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

"""Retire et renvoie l'élément ayant la plus faible priorité d'une file de priorité."""
function pop_lowest!(q::PriorityQueue)
  lowest = q.items[1]
  for item in q.items[2:end]
    if item < lowest
      lowest = item
    end
  end
  idx = findfirst(x -> x == lowest, q.items)
  deleteat!(q.items, idx)
  lowest
end

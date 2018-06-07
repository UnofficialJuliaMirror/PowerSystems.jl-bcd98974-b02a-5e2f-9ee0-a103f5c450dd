#isdefined(Base, :__precompile__) && __precompile__()

module PowerSystems

#################################################################################
# Exports

export PowerSystem

export Line
export Transformer2W
export PhaseShiftingTransformer
export Transformer3W

export Forecast
export Deterministic
export Scenarios
export Probabilistic

export Generator

export HydroGen
export HydroFix
export DispatchHydro
export TechHydro

export RenewableGen
export TechRenewable
export EconRenewable
export RenewableFix
export RenewableCurtailment

export Thermal
export ThermalGen
export ThermalGenSeason
export TechGen
export EconGen

export ElectricLoad
export ShuntElement

export StaticLoad
export ControllableLoad
export InterruptibleLoad
# export FixedShunt
# export FixedAdmittance

export Branch
export Network

export Storage
export GenericBattery

export Bus

#################################################################################
# Imports

import Base.convert

using TimeSeries
using PowerModels
using DataFrames
using CSV
# This packages will be removed with Julia v0.7
using Compat
using NamedTuples

#################################################################################
# Includes

# Include utilities
include("utils/checks.jl")

# PowerSystems models
include("models/topological_elements.jl")
include("models/forecasts.jl")
include("models/network.jl")

#Static types
include("models/generation.jl")
include("models/storage.jl")
include("models/loads.jl")

# Include Parsing files
include("parsers/dict_to_struct.jl")
include("parsers/standardfiles_parser.jl")
include("parsers/csv_parser.jl")

#Definitions of PowerSystem
include("base.jl")

# Better printing
include("utils/print.jl")

end # module end

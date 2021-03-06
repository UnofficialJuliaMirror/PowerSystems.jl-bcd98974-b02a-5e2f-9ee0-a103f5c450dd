import JSON2

function validate_serialization(sys::System)
    #path, io = mktemp()
    # For some reason files aren't getting deleted when written to /tmp. Using current dir.
    path = "test_system_serialization.json"
    io = open(path, "w")
    @info "Serializing to $path"

    try
        IS.prepare_for_serialization!(sys.data, path)
        to_json(io, sys)
    catch
        close(io)
        rm(path)
        rethrow()
    end
    close(io)

    ts_file = nothing
    try
        ts_file = open(path) do file
            JSON2.read(file).data.time_series_storage_file
        end
        sys2 = System(path)
        return IS.compare_values(sys, sys2)
    finally
        @debug "delete temp file" path
        rm(path)
        rm(ts_file)
    end
end

@testset "Test JSON serialization of CDM data" begin
    sys = create_rts_system()
    @test validate_serialization(sys)
    text = JSON2.write(sys)
    @test length(text) > 0
end

@testset "Test JSON serialization of matpower data" begin
    sys = PowerSystems.parse_standard_files(joinpath(MATPOWER_DIR, "case5_re.m"))

    # Add a Probabilistic forecast to get coverage serializing it.
    bus = Bus(nothing)
    bus.name = "Bus1234"
    add_component!(sys, bus)
    tg = RenewableFix(nothing)
    tg.bus = bus
    add_component!(sys, tg)
    tProbabilisticForecast = PSY.Probabilistic("scalingfactor", Hour(1),
                                           DateTime("01-01-01"), [0.5, 0.5], 24)
    add_forecast!(sys, tg, tProbabilisticForecast)

    @test validate_serialization(sys)
end

@testset "Test JSON serialization of ACTIVSg2000 data" begin
    sys = PowerSystems.parse_standard_files(joinpath(DATA_DIR, "ACTIVSg2000",
                                                     "ACTIVSg2000.m"))
    validate_serialization(sys)
end

@testset "Test serialization utility functions" begin
    text = "SomeType{ParameterType1, ParameterType2}"
    type_str, parameters = IS.separate_type_and_parameter_types(text)
    @test type_str == "SomeType"
    @test parameters == ["ParameterType1", "ParameterType2"]

    text = "SomeType"
    type_str, parameters = IS.separate_type_and_parameter_types(text)
    @test type_str == "SomeType"
    @test parameters == []
end

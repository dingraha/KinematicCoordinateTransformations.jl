Test.@testset "Constant velocity transformation" begin

    Test.@testset "Trivial" begin
        t0 = 0.0
        x0 = StaticArrays.SVector(0.0, 0.0, 0.0)
        vel = StaticArrays.SVector(0.0, 0.0, 0.0)
        trans = ConstantVelocityTransformation(t0, x0, vel)
        t = 8.0
        x = [3.0, 4.0, 5.0]
        v = [8.0, 2.0, 2.0]
        a = [2.0, 3.0, 4.0]
        j = [1.0, 2.0, 3.0]
        Test.@inferred trans(t, x, v, a, j)
        x_new, v_new, a_new, j_new = trans(t, x, v, a, j)
        Test.@test x_new ≈ x
        Test.@test v_new ≈ v
        Test.@test a_new ≈ a
        Test.@test j_new ≈ j
    end

    Test.@testset "Coincident origins" begin
        t0 = -2.0
        x0 = StaticArrays.SVector(0.0, 0.0, 0.0)
        vel = StaticArrays.SVector(2.0, 3.0, 4.0)
        trans = ConstantVelocityTransformation(t0, x0, vel)
        t = 8.0
        x = [3.0, 4.0, 5.0]
        v = [8.0, 2.0, 2.0]
        a = [2.0, 3.0, 4.0]
        j = [1.0, 2.0, 3.0]
        Test.@inferred trans(t, x, v, a, j)
        x_new, v_new, a_new, j_new = trans(t, x, v, a, j)
        Test.@test x_new ≈ x + (t - t0)*vel
        Test.@test v_new ≈ v + vel
        Test.@test a_new ≈ a
        Test.@test j_new ≈ j
    end

    Test.@testset "General" begin
        t0 = -2.0
        x0 = StaticArrays.SVector(1.0, 2.0, 3.0)
        vel = StaticArrays.SVector(2.0, 3.0, 4.0)
        trans = ConstantVelocityTransformation(t0, x0, vel)
        t = 8.0
        x = [3.0, 4.0, 5.0]
        v = [8.0, 2.0, 2.0]
        a = [2.0, 3.0, 4.0]
        j = [1.0, 2.0, 3.0]
        Test.@inferred trans(t, x, v, a, j)
        x_new, v_new, a_new, j_new = trans(t, x, v, a, j)
        Test.@test x_new ≈ x + x0 + (t - t0)*vel
        Test.@test v_new ≈ v + vel
        Test.@test a_new ≈ a
        Test.@test j_new ≈ j
    end

end

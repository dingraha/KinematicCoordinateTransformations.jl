@concrete struct ConstantAffineMap <: KinematicTransformation
    # x_new = x_Mx*x + x_b
    x_Mx
    x_b

    # v_new = v_Mx*x + v_Mv*v + v_b
    v_Mx
    v_Mv
    v_b

    # a_new = a_Mx*x + a_Mv*v + a_Ma*a + a_b
    a_Mx
    a_Mv
    a_Ma
    a_b

    # j_new = j_Mx*x + j_Mv*v + j_Ma*a + j_Mj*j + j_b
    j_Mx
    j_Mv
    j_Ma
    j_Mj
    j_b
end

function ConstantAffineMap(t, trans::ConstantAffineMap)
    return trans
end

function (trans::ConstantAffineMap)(t, x, v, a, j)
    x_new = similar(x)
    v_new = similar(v)
    a_new = similar(a)
    j_new = similar(j)

    transform!(x_new, v_new, a_new, j_new, trans, t, x, v, a, j)

    return x_new, v_new, a_new, j_new
end

function transform!(x_new, v_new, a_new, j_new, trans::ConstantAffineMap, t, x, v, a, j)
    # x_new = trans.x_Mx*x                                              .+ trans.x_b
    # v_new = trans.v_Mx*x + trans.v_Mv*v                               .+ trans.v_b
    # a_new = trans.a_Mx*x + trans.a_Mv*v + trans.a_Ma*a                .+ trans.a_b
    # j_new = trans.j_Mx*x + trans.j_Mv*v + trans.j_Ma*a + trans.j_Mj*j .+ trans.j_b

    T = eltype(x_new)
    mul!(x_new, trans.x_Mx, x)
    x_new .+= trans.x_b

    T = eltype(v_new)
    mul!(v_new, trans.v_Mx, x)
    mul!(v_new, trans.v_Mv, v, one(T), one(T))
    v_new .+= trans.v_b
    
    T = eltype(a_new)
    mul!(a_new, trans.a_Mx, x)
    mul!(a_new, trans.a_Mv, v, one(T), one(T))
    mul!(a_new, trans.a_Ma, a, one(T), one(T))
    a_new .+= trans.a_b

    T = eltype(j_new)
    mul!(j_new, trans.j_Mx, x)
    mul!(j_new, trans.j_Mv, v, one(T), one(T))
    mul!(j_new, trans.j_Ma, a, one(T), one(T))
    mul!(j_new, trans.j_Mj, j, one(T), one(T))
    j_new .+= trans.j_b

    return nothing
end

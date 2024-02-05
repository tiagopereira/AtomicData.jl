using Base: Float64

const Ar_H = 1.007975  # Atomic weight of hydrogen
const Ry = R_∞ * c_0 * h  # Rydberg energy
const Ryh = Ry / (1 + m_e / (Ar_H * m_u))  # Hydrogen ionisation energy

"""
    n_eff(energy_upper::Unitful.Energy, energy_lower::Unitful.Energy, Z::Integer)

Compute the effective principal quantum number for a given energy difference
and atomic charge, `Z`= atomic charge + 1 (ie, 1 for neutral, 2 for singly ionised).
`energy_upper` is the ionisation energy for the given stage.
"""
function n_eff(energy_upper::Unitful.Energy, energy_lower::Unitful.Energy, Z::Integer)
    return (Z * sqrt(Ryh / (energy_upper - energy_lower))) |> u"J/J"
end

function n_eff(energy_upper::PerLength, energy_lower::PerLength, Z::Integer)
    e_u = wavenumber_to_energy(energy_upper)
    e_l = wavenumber_to_energy(energy_lower)
    return n_eff(e_u, e_l, Z)
end


"""
If input is in wavenumber, convert to energy. Otherwise keep as energy.
"""
function wavenumber_to_energy(a::Quantity{T}) where T <: AbstractFloat
    if typeof(a) <: PerLength
        a = convert(Unitful.Quantity{T, Unitful.𝐋^2 * Unitful.𝐓^-2 * Unitful.𝐌},
                    (h * c_0 * a) |> u"aJ")
    end
    @assert typeof(a) <: Unitful.Energy{T} "Input units must either be wavenumber or energy"
    return a
end


const ABO_sp_σ =
  [ 126  140  165  202  247  299  346  383  435  491  553  617  685  769  838  925 1011 1082
    140  150  162  183  218  273  327  385  440  501  557  620  701  764  838  923 1025 1085
    154  167  175  192  216  251  299  357  423  487  549  617  684  759  834  910 1014 1064
    166  180  192  206  226  253  291  339  397  459  532  600  676  755  832  896 1002 1055
    208  194  207  223  242  265  296  335  384  445  511  583  656  726  817  889  988 1044
    262  254  220  239  261  283  310  344  388  442  496  568  635  725  791  890  970 1036
    311  306  299  251  280  304  330  361  396  443  500  563  630  704  796  880  951 1033
    358  359  350  338  293  323  352  381  416  455  511  566  635  706  780  859  946 1039
    411  409  405  392  370  340  375  406  439  478  525  580  644  714  790  873  961 1050
    462  463  459  450  443  400  394  432  467  501  546  595  650  711  786  873  963 1050
    522  525  529  524  516  518  438  454  495  532  565  621  671  741  813  874  951 1034
    589  593  590  583  579  568  565  483  517  560  600  644  691  752  821  904  978 1048
    658  655  666  657  649  653  649  587  549  592  674  674  728  782  833  902  992 1084
    738  742  747  725  721  729  699  730  626  622  668  721  765  809  887  938 1001 1109
    838  838  810  809  790  800  769  815  757  679  704  755  806  854  901  974 1034 1105
    942  946  925  901  918  895  919  897  933  890  785  797  859  908  976 1020 1115 1173
   1059 1061 1056 1061 1074 1031 1036 1036  993 1038  932  852  878  943 1003 1074 1131 1200
   1069 1076 1083 1095 1102 1091 1126 1156 1103 1149 1157 1036  972 1007 1064 1124 1209 1283
   1338 1350 1356 1354 1324 1301 1312 1318 1257 1239 1297 1233 1089 1059 1106 1180 1218 1317
   1409 1398 1367 1336 1313 1313 1409 1354 1317 1287 1353 1386 1279 1158 1141 1188 1260 1335
   1328 1332 1342 1369 1405 1451 1502 1524 1506 1477 1522 1594 1572 1436 1328 1325 1382 1446]

const ABO_sp_α =
  [.268 .269 .335 .377 .327 .286 .273 .270 .271 .268 .267 .264 .264 .264 .261 .256 .248 .245
   .261 .256 .254 .282 .327 .355 .321 .293 .287 .271 .267 .273 .270 .270 .268 .268 .264 .263
   .266 .264 .257 .252 .267 .289 .325 .339 .319 .301 .292 .284 .281 .281 .277 .282 .276 .274
   .262 .274 .258 .251 .247 .254 .273 .291 .316 .322 .320 .302 .294 .290 .287 .292 .283 .277
   .322 .275 .264 .259 .250 .245 .273 .255 .271 .284 .294 .308 .296 .299 .288 .289 .282 .278
   .267 .300 .260 .268 .254 .242 .243 .242 .239 .246 .267 .277 .280 .290 .282 .281 .274 .271
   .259 .274 .275 .252 .265 .248 .249 .237 .283 .236 .247 .254 .254 .271 .268 .267 .258 .262
   .260 .255 .268 .268 .268 .264 .248 .239 .229 .240 .236 .234 .238 .244 .252 .251 .244 .255
   .255 .255 .244 .247 .317 .246 .255 .244 .237 .231 .227 .231 .235 .232 .235 .241 .237 .245
   .256 .254 .254 .249 .227 .319 .253 .253 .240 .237 .238 .233 .231 .230 .228 .234 .227 .241
   .257 .254 .252 .235 .253 .240 .284 .251 .246 .241 .235 .228 .222 .225 .225 .219 .228 .233
   .244 .240 .245 .238 .248 .230 .283 .252 .244 .244 .238 .235 .234 .236 .228 .224 .225 .231
   .244 .241 .244 .237 .237 .249 .219 .324 .239 .245 .242 .242 .232 .233 .221 .227 .231 .218
   .241 .245 .249 .239 .243 .250 .217 .254 .308 .237 .247 .244 .234 .228 .233 .224 .227 .226
   .243 .243 .232 .227 .235 .253 .227 .220 .320 .270 .243 .252 .248 .238 .234 .241 .225 .227
   .225 .226 .234 .230 .226 .233 .249 .225 .216 .300 .286 .237 .240 .247 .243 .234 .231 .238
   .268 .260 .247 .238 .233 .241 .254 .248 .207 .227 .315 .260 .226 .237 .240 .239 .239 .240
   .248 .246 .238 .226 .213 .221 .226 .226 .204 .194 .248 .316 .234 .216 .236 .233 .221 .230
   .200 .202 .198 .194 .206 .207 .227 .224 .207 .185 .198 .275 .315 .233 .229 .231 .233 .236
   .202 .209 .221 .226 .230 .245 .202 .257 .246 .225 .215 .246 .320 .321 .244 .239 .251 .253
   .246 .248 .255 .265 .274 .285 .292 .284 .273 .250 .225 .239 .295 .352 .320 .258 .260 .269]

const ABO_sp_np = 1.3:0.1:3.0
const ABO_sp_ns = 1.0:0.1:3.0

const ABO_sp_interp_σ = cubic_spline_interpolation((ABO_sp_ns, ABO_sp_np), ABO_sp_σ,
                                                    extrapolation_bc=Line())
const ABO_sp_interp_α = cubic_spline_interpolation((ABO_sp_ns, ABO_sp_np), ABO_sp_α,
                                                    extrapolation_bc=Line())



"""
Compute Barklem σ and α for an sp transition.

# Arguments
- E_cont: continuum energy (upper continuum of the stage)
- E_lev_s: s level energy
- E_lev_p: p level energy
- Z: atomic charge + 1
"""
function ABO_factors_sp(E_cont, E_lev_s, E_lev_p, Z)
    ns = n_eff(E_cont, E_lev_s, Z)
    np = n_eff(E_cont, E_lev_p, Z)
    α = ABO_sp_interp_α(ns, np)::Float64
    σ = ABO_sp_interp_σ(ns, np)::Float64
    return (σ, α)
end

# ==============================
# This functions converts the 
# Zonotope approximations of the 
# reach sets and saves them as 
# a struct to use in MATLAB
# ==============================

using MAT

function convert_sets(R, dims, orderT, out_file)
	matGen = zeros(length(R), dims, orderT)
	matCenter = zeros(length(R), dims)
	timeZ = zeros(length(R))
	for ss in length(R)
		matGen[ss,:,:] = Array(R.F.Xk[ss].X.generators)
		matCenter[ss,:,:] = Array(R.F.Xk[ss].X.center)
		timeZ[ss] = R.F.Xk[ss].Δt.hi
	end
	matwrite(out_file, Dict("matGen" => matGen,"matCenter" => matCenter, "timeV" => timeZ); compress = false)
	return 
end

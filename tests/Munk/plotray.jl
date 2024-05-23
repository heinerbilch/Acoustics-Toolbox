using Plots
pyplot()

rayfil = ARGS[1]

# Plot the RAYfil produced by Bellhop | Bellhop3D
# usage: plotray( rayfil )
# where rayfil is the ray file
# e.g. plotray( "foofoo.ray" )
#
# for BELLHOP3D files, rays in [x,y,z] are converted to [r,z] coordinates
#
# MBP July 1999

jkpsflag = false

# plots a BELLHOP ray file

open( rayfil, "r" ) do fid   # open the file

# read header stuff

TITLE       = readline( fid )
FREQ        = parse.(Float64, readline( fid ))
Nsxyz       = split(readline( fid ))
NBeamAngles = split(readline(fid))

DEPTHT      = parse.(Float64, readline( fid ))
DEPTHB      = parse.(Float64, readline( fid ))

PlotType = readline( fid )

Nsx = parse.(Int64, Nsxyz[ 1 ])
Nsy = parse.(Int64, Nsxyz[ 2 ])
Nsz = parse.(Int64, Nsxyz[ 3 ])

Nalpha = parse.(Int64, NBeamAngles[ 1 ])
Nbeta  = parse.(Int64, NBeamAngles[ 2 ])

# Extract letters between the quotes
# nchars = strfind( TITLE, "''" );   # find quotes
# TITLE  = [ TITLE[ nchars[ 1 ] + 1 : nchars[ 2 ] - 1 ] blanks( 7 - ( nchars[ 2 ] - nchars[ 1 ] ) ) ]
# TITLE  = deblank( TITLE );  # remove whitespace

# nchars = strfind( Type, "''" );   # find quotes
# Type   = Type1[ nchars[ 1 ] + 1 : nchars[ 2 ] - 1 ]
#Type  = deblank( Type );  # remove whitespace
# read rays


#xlabel( "Range [m]" )
# if ( strcmp( units, "km" ) )
#    xlabel( "Range [km]" )
# end

# axis limits
rmin = +1e9
rmax = -1e9

zmin = +1e9
zmax = -1e9

# this could be changed to a forever loop
for isz = 1 : Nsz
   plot(title = TITLE, yflip = true, xlabel = "Range [m]", ylabel = "Depth [m]", legend = false, reuse = false)
   for ibeam = 1 : Nalpha
      alpha0    = parse.(Float64, readline( fid ))
      steps = split(readline(fid))
      nsteps    = parse.(Int64, steps[1])
      NumTopBnc = parse.(Int64, steps[2])
      NumBotBnc = parse.(Int64, steps[3])
      r = fill(NaN, nsteps)
      z = fill(NaN, nsteps)
      for i in 1:nsteps
#        switch PlotType
#          case "rz"
            ray = split(readline(fid))
            r[i], z[i] = parse.((Float64, Float64), ray)
#          case "xyz"
#             ray = fscanf( fid, "#f", [3 nsteps] )
            
#             xs = ray[ 1, 1 ]
#             ys = ray[ 2, 1 ]
#             r = sqrt( ( ray[ 1, : ] - xs ).^2 + ( ray[ 2, : ] - ys ).^2 )
#             z = ray[ 3, : ]
#        end # switch
      end # nsteps
      
#       if ( strcmp( units, "km" ) )
#          r = r / 1000;   # convert to km
#       end
      
      if NumTopBnc >= 1 && NumBotBnc >= 1
         plot!(r, z, lc=:black )    # hits both boundaries
      elseif NumBotBnc >= 1
         plot!(r, z, lc=:blue )	   # hits bottom only
      elseif NumTopBnc >= 1
         plot!(r, z, lc=:green )	   # hits surface only
      else()
         plot!(r, z, lc=:red )    # direct path()
      end
      
      # update axis limits
#      rmin = min( [ r rmin ] )
#      rmax = max( [ r rmax ] )

#      zmin = min( [ z zmin ] )
#      zmax = max( [ z zmax ] )
#      if ( zmin .== zmax ) # horizontal ray causes axis scaling problem
#         zmax = zmin + 1
#      end
#      axis( [ rmin, rmax, zmin, zmax ] )
      
      # flush graphics buffer every 10th ray
      # (does not work for an eigenray run because Nalpha is number of rays
      # traced, not number of eigenrays)
#      if rem( ibeam, fix( Nalpha / 10 ) ) .== 0
#         drawnow()
#      end

   end	# next beam
gui()
end # next source depth
end # read loop





cmake_minimum_required(VERSION 2.8)

project(Precompiled)
#SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/..)

# Libraries

file( GLOB_RECURSE precomp_files RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/all/" "all/*" )
foreach( precomp_file ${precomp_files} )
  if ( NOT ${precomp_file} MATCHES ".svn" ) 
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}"
    COMMAND ${CMAKE_COMMAND} -E copy
"${CMAKE_CURRENT_SOURCE_DIR}/all/${precomp_file}"
"${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/all/${precomp_file}"
  )
#  message ("${CMAKE_CURRENT_SOURCE_DIR}/all/${precomp_file} ${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}")
  list( APPEND precomp_files_dest "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}" )
  endif()
endforeach( precomp_file )

file( GLOB_RECURSE precomp_files RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/MIN/" "MIN/*" )
foreach( precomp_file ${precomp_files} )
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}"
    COMMAND ${CMAKE_COMMAND} -E copy
"${CMAKE_CURRENT_SOURCE_DIR}/MIN/${precomp_file}"
"${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/MIN/${precomp_file}"
	)
  list( APPEND precomp_files_dest "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}" )
endforeach( precomp_file )

if ( WIN32 )
	file( GLOB_RECURSE precomp_files RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/WIN32/" "WIN32/*" )
	foreach( precomp_file ${precomp_files} )
	  add_custom_command(
		OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}"
		COMMAND ${CMAKE_COMMAND} -E copy
    	    "${CMAKE_CURRENT_SOURCE_DIR}/WIN32/${precomp_file}"
	        "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}"
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/WIN32/${precomp_file}"
		)
	  list( APPEND precomp_files_dest "${CMAKE_CURRENT_BINARY_DIR}/../${precomp_file}" )
	endforeach( precomp_file )
endif()



add_custom_target( CopyPrecomp ALL DEPENDS ${precomp_files_dest} ) 


#set (PRECOMPALL
#configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/all/
#demo/advanced.doc
#demo/advanced.pdf
#demo/Bruce/Bruce.doc
#demo/Bruce/Bruce.pdf
#demo/Bruce/shelx4.hkl
#demo/Bruce/shelx5.hkl
#demo/Bruce/shelxs.ins
#demo/Bruce/start.cif
#demo/Bruce/twinlaw.txt
#demo/chargeflip/chargeflip/CCDC677069/CCDC677069.hkl
#demo/chargeflip/chargeflip/CCDC677069/CCDC677069.ins
#demo/chargeflip/chargeflip/crystals_chargeflip.pdf
#demo/chargeflip/chargeflip/florina/flo19.hkl
#demo/chargeflip/chargeflip/florina/flo19.ins
#demo/chargeflip/chargeflip/FOYTAO01/FOYTAO01.hkl
#demo/chargeflip/chargeflip/FOYTAO01/FOYTAO01.ins
#demo/chargeflip/chargeflip/IUCRbt6337/bt6337.hkl
#demo/chargeflip/chargeflip/IUCRbt6337/bt6337.ins
#demo/chargeflip/chargeflip/Llewellyn/Llewellyn.hkl
#demo/chargeflip/chargeflip/Llewellyn/Llewellyn.ins
#demo/chargeflip/crystals_workshop_osaka.pdf
#demo/cyclo/bca.hkl
#demo/cyclo/bca.ins
#demo/cyclo/crystart.dat
#demo/cyclo/cyclo-A4.pdf
#demo/cyclo/cyclo-A4.ppt
#demo/cyclo/cyclo.hkl
#demo/cyclo/cyclo.ins
#demo/cyclo/cyclo.txt
#demo/cyclo/import.cif
#demo/cyclo/kccd.cif
#demo/demo/crystart.dat
#demo/Demos.doc
#demo/disorder/crystart.dat
#demo/disorder/disorder.doc
#demo/disorder/disorder.pdf
#demo/disorder/import.cif
#demo/disorder/linden.txt
#demo/editor/crystart.dat
#demo/editor/editor.txt
#demo/editor/editors.doc
#demo/editor/editors.pdf
#demo/editor/work1.dat
#demo/editor/work2.dat
#demo/editor/work3.dat
#demo/editor/work4.dat
#demo/example/hex.hkl
#demo/example/hexample.dat
#demo/example/hexquick.dat
#demo/Hydrogen/hydrogen.hkl
#demo/Hydrogen/hydrogen.ins
#demo/Hydrogen/import.cif
#demo/keen/crystart.dat
#demo/keen/Keen-twin.doc
#demo/keen/Keen-twin.pdf
#demo/keen/keen.hkl
#demo/keen/keen.ins
#demo/keen/keen.txt
#demo/kpenv/import.cif
#demo/llewellyn/arc811.ccf
#demo/llewellyn/arc811.hkl
#demo/llewellyn/crystart.dat
#demo/llewellyn/llewellyn.doc
#demo/llewellyn/llewellyn.pdf
#demo/llewellyn/LLewellyn.txt
#demo/mogul/mogul1.dat
#demo/mogul/mogul2.dat
#demo/mogul/mogul3.dat
#demo/mogul/mogul3.txt
#demo/nket/nket.abs
#demo/nket/nket.ani
#demo/nket/nket.dat
#demo/nket/nket.doc
#demo/nket/nket.dsc
#demo/nket/nket.fou
#demo/nket/nket.hkl
#demo/nket/nket.lsq
#demo/nket/nket.psi
#demo/nket/nket.qck
#demo/nket/nket.ref
#demo/nket/nket.scf
#demo/nket/nket.slx
#demo/nket/nket.wp
#demo/peach/crystart.dat
#demo/peach/import.cif
#demo/peach/peach.doc
#demo/peach/peach.hkl
#demo/peach/peach.ins
#demo/peach/peach.pdf
#demo/peach/peach.txt
#demo/quick/crystart.dat
#demo/quick/quickslow.txt
#demo/quick/tetra.doc
#demo/quick/tetra.pdf
#demo/quick/veryfast.hkl
#demo/quick/veryfast.ins
#demo/shape/crystart.dat
#demo/shape/newaniso.dsc
#demo/shape/newiso.dsc
#demo/shape/newring.dsc
#demo/shape/orig.dsc
#demo/shape/rucpd.txt
#demo/shape/shape.doc
#demo/shape/shape.pdf
#demo/shape/zngapo.dat
#demo/shape/zngapo.hkl
#demo/shape2/zngapo.dat
#demo/shape2/zngapo.hkl
#demo/SO3-disorder/import.cif
#demo/SO3-disorder/SO3-disorder.doc
#demo/SO3-disorder/SO3-disorder.pdf
#demo/Sugar-disorder/sugar-disorder-1.pdf
#demo/Sugar-disorder/sugar-disorder.doc
#demo/Sugar-disorder/sugar.hkl
#demo/Sugar-disorder/sugar.ins
#demo/twin/crystart.dat
#demo/twin/me3snh.hkl
#demo/twin/me3snh.ins
#demo/twin/Tin-Twin.doc
#demo/twin/tin-twin.pdf
#demo/twin/twin.txt
#demo/twin2/as19a2.hkl
#demo/twin2/as19a2.ins
#demo/twin2/crystart.dat
#demo/twin2/Twin-2.doc
#demo/twin2/twin-2.pdf
#demo/twin2/twin2.txt
#demo/twin3/crystart.dat
#demo/twin3/hibflq.hkl
#demo/twin3/hibflq.ins
#demo/twin3/twin-3.doc
#demo/twin3/twin-3.pdf
#demo/twin3/twin3.txt
#demo/ylid/crystart.dat
#demo/ylid/ylid.doc
#demo/ylid/ylid.hkl
#demo/ylid/ylid.ins
#demo/ylid/ylid.pdf
#demo/ylid/ylid.txt
#demo/zoltan/crystart.dat
#demo/zoltan/import.cif
#demo/zoltan/zoltan.txt
#form.dat
#rc93.srt
#script/adpcol16.bmp
#script/adpcol256.bmp
#script/button.cmn
#script/ccdclogo.bmp
#script/colour.cmn
#script/command.cmn
#script/ed12.bmp
#script/ed16.bmp
#script/ed5.bmp
#script/explorer.bmp
#script/genhelp.cmn
#script/guide1.bmp
#script/guide2.bmp
#script/guide3.bmp
#script/guide4.bmp
#script/h11.bmp
#script/h12.bmp
#script/h13.bmp
#script/h22.bmp
#script/h23.bmp
#script/h33.bmp
#script/hbond.bmp
#script/hphen.bmp
#script/layout.html
#script/mercury.bmp
#script/monoclinic.bmp
#script/notepad.bmp
#script/order.cmn
#script/pale-layout.gif
#script/pale-layout.pdf
#script/polaroid.bmp
#script/prop.cmn
#script/prout.bmp
#script/refine.bmp
#script/sysabs1.bmp
#script/sysabs2.bmp
#script/tetragonal.bmp
#script/title.cmn
#script/tl_delh.bmp
#script/tl_delq.bmp
#script/tl_perh.bmp
#script/tool_adp.bmp
#script/tool_ball.bmp
#script/tool_guid.bmp
#script/tool_help.bmp
#script/tool_norm.bmp
#script/tool_opt.bmp
#script/tool_poly.bmp
#script/tool_rect.bmp
#script/tool_rot.bmp
#script/tool_showh.bmp
#script/tool_unsl.bmp
#script/tool_zoom.bmp
#script/toolcam.bmp
#script/toolfour.bmp
#script/undo.bmp
#script/watkin.bmp
#script/Wincrys.gif
#script/wwtbct1.bmp
#script/wwtblogot.bmp
#Tables.txt
#)
#
#
#set (prefiles)
#foreach(_file ${PRECOMPALL})
#   list(APPEND prefiles ${CMAKE_CURRENT_SOURCE_DIR}/all/${_file})
#if (APPLE)
#   add_custom_command(
#      OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${_file}
#      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/all/${_file} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${_file}
#      MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/all/${_file})
#else()
#   add_custom_command(
#      OUTPUT ${_file}
#      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/all/${_file} ${_file}
##      COMMAND echo "copy ${CMAKE_CURRENT_SOURCE_DIR}/all/${_file} ${_file}"
#      MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/all/${_file})
#endif()
#endforeach()
#
#
#add_custom_target(do_precompiled ALL echo DEPENDS ${prefiles})
#
#


SET(CMAKE_BUILD_TYPE Release)
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

PROJECT(Manual)

file(GLOB JPGS "${CMAKE_CURRENT_SOURCE_DIR}/*.jpg")
file(GLOB GIFS "${CMAKE_CURRENT_SOURCE_DIR}/*.gif")
file(GLOB CSSS "${CMAKE_CURRENT_SOURCE_DIR}/*.css")
file(GLOB PDFS "${CMAKE_CURRENT_SOURCE_DIR}/*.pdf")
file(GLOB ANALYSE "${CMAKE_CURRENT_SOURCE_DIR}/analyse/*")
file(GLOB XRAYDAT "${CMAKE_CURRENT_SOURCE_DIR}/Xray-data/*")


# GUI version uses crystalscl helper to build dsc file as intermediate step...
ADD_CUSTOM_COMMAND(
	OUTPUT  manual.stamp
	COMMAND ${CMAKE_COMMAND} -E make_directory analyse
	COMMAND ${CMAKE_COMMAND} -E make_directory Xray-data
	COMMAND ${CMAKE_COMMAND} -E env CRYSSRC=${CMAKE_SOURCE_DIR} ${PERL_EXECUTABLE}  -w ${CMAKE_CURRENT_SOURCE_DIR}/mangen.pl faq.man primer.man guide.man crystals.man cameron.man menu.man readme.man workshop.man
	COMMAND ${CMAKE_COMMAND} -E copy ${JPGS} .
	COMMAND ${CMAKE_COMMAND} -E copy ${GIFS} .
	COMMAND ${CMAKE_COMMAND} -E copy ${CSSS} .
	COMMAND ${CMAKE_COMMAND} -E copy ${PDFS} .
	#COMMAND ${CMAKE_COMMAND} -E copy ${ANALYSE} ./analyse
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/analyse ./analyse
	COMMAND ${CMAKE_COMMAND} -E copy ${XRAYDAT} ./Xray-data
	COMMAND ${CMAKE_COMMAND} -E touch manual.stamp
	COMMAND ${CMAKE_COMMAND} -E remove_directory html
	COMMAND ${CMAKE_COMMAND} -E remove_directory latex
	COMMAND ${CMAKE_COMMAND} -E remove_directory website
    COMMENT "Processing manual"
	DEPENDS ../../manual/faq.man ../../manual/primer.man ../../manual/guide.man ../../manual/crystals.man ../../manual/cameron.man ../../manual/menu.man ../../manual/readme.man ../../manual/workshop.man
)

add_custom_target(
    manual ALL
    DEPENDS manual.stamp
)

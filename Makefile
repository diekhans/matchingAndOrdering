rootPath = .
include ${rootPath}/include.mk

export PYTHONPATH = ../sonLib/src:..

libSources = impl/*.c
libHeaders = inc/*.h
libTests = tests/*.c
testBin = tests/testBin

all : externalToolsM ${libPath}/matchingAndOrdering.a ${binPath}/matchingAndOrderingTests ${testBin}/referenceMedianProblemTest2

externalToolsM : 
	cd externalTools && ${MAKE} all

${libPath}/matchingAndOrdering.a : ${libSources} ${libHeaders} ${basicLibsDependencies} 
	${cxx} ${cflags} -I inc -I ${libPath}/ -c ${libSources}
	ar rc matchingAndOrdering.a *.o
	ranlib matchingAndOrdering.a 
	rm *.o
	mv matchingAndOrdering.a ${libPath}/
	cp ${libHeaders} ${libPath}/

${binPath}/matchingAndOrderingTests : ${libTests} ${libSources} ${libHeaders} ${libPath}/matchingAndOrdering.a ${basicLibsDependencies} 
	${cxx} ${cflags} -I inc -I impl -I${libPath} -o ${binPath}/matchingAndOrderingTests ${libTests} ${libPath}/matchingAndOrdering.a ${basicLibs}

${testBin}/referenceMedianProblemTest2 : ${testBin}/referenceMedianProblemTest2.c ${libSources} ${libHeaders} ${libPath}/matchingAndOrdering.a ${basicLibsDependencies} 
	${cxx} ${cflags} -I inc -I impl -I${libPath} -o ${testBin}/referenceMedianProblemTest2 ${testBin}/referenceMedianProblemTest2.c ${libPath}/matchingAndOrdering.a ${basicLibs}

clean : 
	cd externalTools && ${MAKE} clean
	rm -f *.o
	rm -f ${libPath}/matchingAndOrdering.a ${binPath}/matchingAndOrderingTests ${testBin}/referenceMedianProblemTest

test : all
	python allTests.py

#! python 
import os, glob, commands, re, string, sys;

def endingThing(string, ending, dictionary) :
	if not dictionary.has_key(ending) : dictionary[ending] = []
	if string.endswith(ending) :
		dictionary[ending].append(string)
	return dictionary
		
def endingThing2(string, endings, dictionary) :
	return reduce(lambda x, y: endingThing(string, y, x), endings, dictionary)

def askQuestion(question, default_response, valid_responses=[]):
	dontExit = True
	while dontExit :
		sys.stdout.write(question+ '[' + default_response + ']')
		result = sys.stdin.readline().strip()
		result = ((len(result) == 0) and default_response) or result
		if len(valid_responses) > 0:
			valid_results = filter(lambda valid_response, response=result: valid_response.startswith(response), valid_responses)
			if len(valid_results) == 1:
				result = valid_results[0]
				return result
		else:
			return result
		print 'Invalid input.'
	
class InstallPath:
	def __init__(self, symbol_dict, default='@executable_path/../Libraries/'):
		self.default_install_path = default
		self.symbols_dictionary = symbol_dict
		
	def askFor(self):
		self.default_install_path = askQuestion('Select install directory:', self.default_install_path)
		print 'Install path is ' + self.default_install_path
		return self.default_install_path
		
	def path(self):
		return self.default_install_path
		
	def fullPath(self):
		return reduce(lambda pstring, symbol, symbol_dict=self.symbols_dictionary: pstring.replace(symbol, symbol_dict[symbol]), self.symbols_dictionary.keys(), self.default_install_path)
		
	def createPath(self):
		if not os.path.isdir(self.fullPath()) :
			os.makedirs(self.fullPath())
		
class LibraryLocation:
	def __init__(self, path):
		self.iPath = path
		
	def libraries(self):
		return Libraries(glob.glob(self.iPath + 'lib*'))
		
class Libraries:
	def __init__(self, files):
		self.libs = files;
		
	def __add__(self, otherLibrary):
		self.libs = self.libs + otherLibrary.libs
		return self
		
	def dylibs(self):
		return Libraries(filter(lambda x: x.endswith('.dylib'), self.libs))
		
	def as(self):
		return Libraries(filter(lambda x: x.endswith('.a'), self.libs))
		
	def frameworks(self):
		return Libraries(filter(lambda x: x.find('.framework') != -1, self.libs))
		
	def list(self):
		return self.libs
	
	def endingsAreOf(self, files):
		return reduce(lambda x, y: endingThing2(y, self.libs, x), files, {})
		
class otool:
	def __init__(self):
		self.libraryMatcher = re.compile('^\s+([^\@\s]\S+)\s+(\(.+\))')
		
	def librariesFor(self, executable):
		result = commands.getstatusoutput('otool -L ' + executable)
		if result[0] != 0 : raise '"otool -L" failed ', result[0]
		return  Libraries([x.groups()[0] for x in map(\
			lambda x: self.libraryMatcher.search(x), result[1].splitlines()) if x != None])
		
	def librariesWithVersionFor(self, executable):
		result = commands.getstatusoutput('otool -L ' + executable)
		if result[0] != 0 : raise '"otool -L" failed ', result[0]
		result = filter(lambda x: x != None, map(lambda x: self.libraryMatcher.search(x), result[1].splitlines()))
		return (Libraries([x.groups()[0] for x in result]), [x.groups()[1] for x in result])
		
class FunCall:
	def __init__(self, function, *args, **kargs):
		self.function = function
		self.args = args
		self.kargs = kargs
		
	def __call__(self, *args, **kargs):
		if kargs and self.kargs :
			d = self.kargs
			d.update(kargs)
		else:
			d = self.kargs
		return self.function(*(self.args + args), **d)
	
def applyToAll(func, list, *args):
	for x in list : apply(func, (x, ) + args)
	
def ifFun(condition, iffunc, elsefunc):
	if condition : return iffunc()
	else : return elsefunc()
	
def makeRealPaths(dictionary, key):
	dictionary[key] = os.path.realpath(dictionary[key])
	return dictionary

exception = 'My exception'	

def raiseException(pException):
	raise exception, pException
	
def takeFirstElement(key, dict):
	dict[key] = dict[key][0]
	return dict

executable = 'Crystals.app/Contents/MacOS/Crystals'

class cache(dict):
	def __init__(self, filename):
		dict.__init__(self)
		self.filename = filename
		if os.path.exists(filename):
			print 'Using ' + self.filename +' file for run. To run using new options remove ' + self.filename +' file.'
			cachefile = open(self.filename, 'r')	
			cachestring = cachefile.read().strip()
			cachefile.close()
			if len(cachestring) > 0 :
				self.update(eval(cachestring))
			
	def __del__(self):	
		cachefile = open(self.filename, 'w')
		cachefile.write(str(self))
		cachefile.close()

def change_lib_installation(old_reference, file, install_path, executable, response_cache):
	if response_cache.has_key(old_reference):
		response = response_cache[old_reference]
	else:
		response = askQuestion('Relink ' + old_reference + '?', 'y', ['yes', 'no'])
	response_cache[old_reference] = response
	if response=='yes':
		lib_name = os.path.basename(file)
		print lib_name
		result = commands.getstatusoutput('cp ' + file + ' ' + install_path.fullPath() + lib_name)
		if  result[0] != 0:
			print result[1]
			raiseException('Problem with cp.')
		print 'install_name_tool -change ' + old_reference + ' ' + install_path.path() + lib_name + ' ' + executable
		result = commands.getstatusoutput('install_name_tool -change ' + old_reference + ' ' + install_path.path() + lib_name + ' ' + executable)
		if result[0] != 0:
			print result[1]
			raiseException('Problem with install_name_tool.')



try:
	thecache = cache('LibMove.cache')
	install_path = InstallPath({'@executable_path':os.path.dirname(os.path.abspath(executable))})
	if thecache.has_key('DefaultLibPath'):
		install_path = InstallPath({'@executable_path':os.path.dirname(os.path.abspath(executable))}, thecache['DefaultLibPath'])
	else :
		install_path = InstallPath({'@executable_path':os.path.dirname(os.path.abspath(executable))})
		thecache['DefaultLibPath'] = install_path.askFor()

	otoolObj = otool()
	crystals_libs = otoolObj.librariesFor(executable)
	libraries = LibraryLocation('/usr/local/lib/').libraries() \
		+ LibraryLocation('/usr/lib/').libraries() \
		+ LibraryLocation('/lib/').libraries() \
		
	matches = crystals_libs.dylibs().endingsAreOf(libraries.dylibs().list())
	
	keys = matches.keys()
	matches = reduce(lambda dict, key: ifFun(len(dict[key]) == 1, FunCall(takeFirstElement, key, dict), \
		FunCall(lambda x: raiseException('A single match for ' + x + ' was not found! \n'), key)), keys, matches)
	matches = reduce(makeRealPaths, keys, matches)
	if not thecache.has_key('Libraries'):
		thecache['Libraries'] = {}
	install_path.createPath()
	applyToAll(lambda key, dict, *args:change_lib_installation(key, dict[key], *args), matches.keys(), matches, install_path, executable, thecache['Libraries'])
except exception, message:
	print message




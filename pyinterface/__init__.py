
import os

print "in init!"

_ROOT = os.path.abspath(os.path.dirname(__file__))

def get_path(path):
	print 'Returning ' + os.path.join(_ROOT,path)
	return os.path.join(_ROOT,path)
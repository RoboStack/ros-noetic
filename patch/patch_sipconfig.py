import os

prefix = os.environ.get('PREFIX')

with open(os.path.join(prefix, 'Lib/site-packages/sipconfig.py')) as fi:
	lines = fi.readlines()
	print("\n\nREAD IN SIPCONFIG", lines)

lines[1001:1001] = """

        if sys.platform == "win32":
            lib += '_conda'

"""

with open(os.path.join(prefix, 'Lib/site-packages/sipconfig.py'), 'w') as fo:
	print("WRITING PATCH SIPCONFIG")
	fo.write(''.join(lines))

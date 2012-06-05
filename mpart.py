import cgitb
import cgi
import os, sys
import tempfile

# Generator to buffer file chunks
def fbuffer(f, chunk_size=10000):
   while True:
      chunk = f.read(chunk_size)
      if not chunk: break
      yield chunk

cgitb.enable()

form = cgi.FieldStorage()

for param in form:
	fd, temp = tempfile.mkstemp()
	f = open(temp, 'wb', 10000)
	if form[param].filename:
		# Read the file in chunks
		for chunk in fbuffer(form[param].file):
			f.write(chunk)
		f.close()
		if not ";" in param and not ";" in form[param].filename:
			print "file;" + param.replace(" ", "%20") + ";" + temp.replace(" ", "%20") + ";" + form[param].filename.replace(" ", "%20")
	else:
		# Write param to the file
		f.write(form[param].value)
		f.close()
		if not ";" in param:
			print "param;" + param.replace(" ", "%20") + ";" + temp.replace(" ", "%20")

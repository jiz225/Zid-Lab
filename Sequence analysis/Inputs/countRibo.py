import sys
def countRibo(destdir, inputpath):
	file1 = open(inputpath,'r')
	names = inputpath.split('/')
	names1 = names[len(names) - 1].split('-f')
	#temp = inputpath.split('.')[0] + str('-temp.csv')
	filename = str(destdir) + names1[len(names1) - 2] + str('-aligned.txt')
	#output = open(temp, 'w')
	output = open(filename, 'w')
	print(filename)
	for line in file1:
		if not line.startswith('@'):
			strs = line.split('\t')
			inputs = []
			if str(strs[1]) == '16':
				inputs.append('-')
			else:
				inputs.append('+')
			chromnum = strs[2][3:]
			if chromnum[0] == '0':
				chromnum = chromnum[1]
			inputs.append(chromnum)
			inputs.append('1')
			inputs.append(strs[3])
			#print(inputs)
			for i in range(len(inputs)):
				output.write(inputs[i])
				output.write('\t')
			output.write('\n')	
	return			
countRibo(sys.argv[1], sys.argv[2])

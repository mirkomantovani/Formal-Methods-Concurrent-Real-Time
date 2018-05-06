import sys
import csv

def pred(a, b):
	"return the predicate of adjacency associated to the two areas"
	# a, b are two indexes
	area_a = "L{}".format(a)
	area_b = "L{}".format(b)
	return "Adj({}, {})".format(area_a, area_b)


if __name__ == "__main__":
	with open('adj-matrix.csv', 'r') as csvfile:
		matrix = csv.reader(csvfile, delimiter=';')
		output = ''
		skip = True
		for row in matrix:
			if skip:
				skip = False
				continue
			for i in range(1, len(row)):
				column = i - 1
				if row[i] == '0':
					output += " (not {})".format(pred(row[0], column))	
				elif row[i] == '1':
					output += " {}".format(pred(row[0], column))	
		print("(and {})".format(output))

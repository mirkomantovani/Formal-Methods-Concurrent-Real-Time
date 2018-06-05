import sys
import csv

def pred(a, b):
    "return the predicate of adjacency associated to the two areas"
    # a, b are two indexes
    if a == "BA":
        a = 13
    elif a == "TB":
        a = 14
    elif a == "CB":
        a = 15
    return "-P- adjacent {} {}".format(a, b)


if __name__ == "__main__":
    with open('adj-matrix.csv', 'r') as csvfile:
        matrix = csv.reader(csvfile, delimiter=',')
        output = ''
        skip = True
        for row in matrix:
            if skip:
                skip = False
                continue
            for i in range(1, len(row)):
                if row[i] == '0':
                    output += " (not ({}))".format(pred(row[0], i))
                elif row[i] == '1':
                    output += " ({})".format(pred(row[0], i))
        print('(and {})'.format(output))
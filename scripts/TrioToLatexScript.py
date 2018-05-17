import re

if __name__ == "__main__":

    path_to_file = "RobotController.trio"

    substitutions = []

    substitutions.append(["Futr", "\\ ftr"])  # problem
    substitutions.append(["ftr", " future"])  # problem
    substitutions.append(["Becomes", "\\ bcm"])  # problem
    substitutions.append([" bcm", "becomes"])  # problem

    substitutions.append(["=>","\\limply"])
    substitutions.append(["\\neg \\\\exists", "\\nexists"])
    substitutions.append(["\\\\implies", "\\limply"])
    substitutions.append(["<=>", "\\liff"])
    substitutions.append(["&&", "\\land"])
    # substitutions.append(["||", "\\lor"])
    substitutions.append(["\\not", "\\lnot"])
    substitutions.append(["Not", "\\lnot"])
    substitutions.append(["notexists", "\\nexists"])

    substitutions.append(["exists", "\\exists"])
    substitutions.append(["Not", "\\lnot"])
    substitutions.append(["Until", "\\until"])
    substitutions.append(["Since", "\\since"])
    substitutions.append(["NextTime", "\\nexttime"])
    substitutions.append(["UpToNow", "\\uptonow"])
    substitutions.append(["Within", "\\within"])
    substitutions.append(["Alw", "\\always"])
    substitutions.append(["SomF", "\\sometimeFuture"])
    substitutions.append(["Past", "\\past"])
    substitutions.append(["Lasts", "\\lasts"])
    substitutions.append(["Lasted", "\\lastedOp"])


    # print(substitutions[0][1])

    with open(path_to_file, 'r') as trioFile:
        text = trioFile.read()

    for s in substitutions:
         pattern = s[0]
         sub = s[1]
         text = re.sub(pattern, sub, text)

    print(text)
    with open('latex'+path_to_file, 'w') as latexFile:
         latexFile.write(text)

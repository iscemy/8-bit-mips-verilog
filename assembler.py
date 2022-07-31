import sys

from matplotlib import lines

instructionLUT = {
"jmp"   :0,
"lb"    :1,
"sb"    :2,
"li"    :3,
"add"   :4,
"sub"   :5,
"and_"  :6,
"or_"   :7,
"invert":8,
"lsl"   :9,
"lsr"   :10,
"beq"   :11,
"bne"   :12,
"slt"   :13
}

addressingTypeLUT = {
"jmp"   :"j",
"lb"    :"i",
"sb"    :"i",
"li"    :"i",
"add"   :"r",
"sub"   :"r",
"and_"  :"r",
"or_"   :"r",
"invert":"r",
"lsl"   :"r",
"lsr"   :"r",
"beq"   :"j",
"bne"   :"j",
"slt"   :"r"
}

registerLUT = {
    "r0":0,
    "r1":1,
    "r2":2,
    "r3":3
}

labelsLUT = {

}

def aReg(r, pos):
    r = r.replace(" ", "")
    return int(registerLUT[r])<<pos
def twoComp(num, size = 8):
    if(num > 0):
        if(pow(2, size-1) - 1) >= num:
            return num
    elif(num < 0):
        num = abs(num)
        if(pow(2, size-1)) >= num:
            return (1<<size) - num 
    else:
        return 0

def getBranchingAddress(argument, c):
    argument = argument.replace("\n", "")
    argument = argument.replace(" ", "")
    if(str.isdigit(argument.replace("-", ""))):
        return twoComp(int(argument))
    else:
        if(argument in labelsLUT):
            return twoComp(labelsLUT[argument] - c)
        else:
            raise Exception("label not found " + str(c))

def assembleLine(line, count):
    line = line.replace('\n', '')
    count += 1
    line_splitted = line.split(",")
    instruct = line_splitted[0]

    if(instruct.find(":") != -1):
        
        label, instruct =  instruct.split(":")

        print("label is detected " + label)

    args = [instruct.split(" ")[-1]]
    instruct, arg0 = list(filter(("").__ne__, instruct.split(" ")))
     

    args = line_splitted[1:]
    args.insert(0, arg0)
    machineCode = 0
    if addressingTypeLUT.get(instruct):
        print("instruct " + instruct)
        print(args)
        if(addressingTypeLUT[instruct] == "j"):
            if(instruct == "jmp"): ##and other one parameter insturctions falls to here
                if(len(args) == 1):
                    machineCode = ((instructionLUT[instruct]<<12) + getBranchingAddress(args[0]))
                else:
                    raise Exception("err line :" + str(count))
            else: ##beq, bne
                if(len(args) != 3):
                    raise Exception("err line :" + str(count))
                else:
                    print(args)
                    machineCode = ((instructionLUT[instruct]<<12) + 
                    aReg(args[0],10) + aReg(args[1],8) + getBranchingAddress(args[2], count))


        elif(addressingTypeLUT[instruct] == "r"):
            if(len(args) != 3):
                raise Exception("err line " + str(count))
            else:
                machineCode = ((instructionLUT[instruct]<<12) + 
                aReg(args[0],10) + aReg(args[1],8) + aReg(args[2],6))

        elif(addressingTypeLUT[instruct] == "i"):
                if(len(args) != 3):
                    raise Exception("err line :" + str(count))
                else:
                    print(args)
                    machineCode = ((instructionLUT[instruct]<<12) + 
                    aReg(args[0],10) + aReg(args[1],8) + twoComp(int(args[2])))

    else:
        print("line " + str(count) + " unknown instruct")    

    return machineCode

def findAndRemoveLabels(Lines):
    c = 0
    code = []
    for line in Lines:
        if(line.find(":") != -1):
            line_s = line.split(":")
            label = line_s[0].replace(" ", "")
            labelsLUT[label] = c
            code.append(line_s[1])
        else:
            code.append(line)
        c += 1
    return code

machineCode = []

try:
    fileName = sys.argv[1]
except:
    fileName = "test.a"

file = open(fileName, 'r')
Lines = file.readlines()

Lines = (findAndRemoveLabels(Lines))

machineCodes = []
c = 0
for line in Lines:
    machineCodes.append(assembleLine(line, c))
    c += 1

print("i = 0;")
for mc in machineCodes:
    s = format(mc, '#018b')[2:]
    print("mem[i] = 16'b"+s+";")
    print("i = i + 1;")
# print(bin(twoComp(-20)))
# b0100 01 00 00 000000;
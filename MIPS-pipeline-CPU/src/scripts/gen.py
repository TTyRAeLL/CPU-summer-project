with open('data.txt', 'r') as data:
    a = data.readlines()
    with open('a.out','w') as o:
        for line in a:
            o.write('%#x\n' % int(line[:-1], 16))
            print('%#x'%int(line[:-1], 16))

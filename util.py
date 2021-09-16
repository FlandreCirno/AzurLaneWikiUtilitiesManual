# -*- coding: utf-8 -*-
import re, os, json
from slpp import slpp

DataDirectory = os.path.join('AzurLaneData', 'zh-CN')
JsonDirectory = 'json'
WikiDirectory = 'Wiki'

def saveJsonFile(data, fileName):
    with open(os.path.join(JsonDirectory, fileName + '.json'), 'w', encoding='utf-8') as f:
        json.dump(data, f, sort_keys = True, indent = 4, separators = (',', ': '))
        
def loadJsonFile(fileName):
    with open(os.path.join(JsonDirectory, fileName + '.json'), 'r+', encoding='utf-8') as f:
        content = json.load(f)
        return parseJson(content)

def parseJson(data):
    if isinstance(data, dict):
        output = {}
        for k, v in data.items():
            if isinstance(k, str) and k.isdigit():
                output[int(k)] = parseJson(v)
            else:
                output[k] = parseJson(v)
    elif isinstance(data, list):
        output = []
        for i in data:
            output.append(parseJson(i))
    else:
        output = data
    return output

def hasJsonFile(fileName):
    return os.path.isfile(os.path.join(JsonDirectory, fileName + '.json'))

def parseDataFile(fileName, filePath = r'sharecfg', mode = 0):
    if hasJsonFile(fileName):
        return loadJsonFile(fileName)
    else:
        output = {}
        if mode == 0:
            filePath = os.path.join(DataDirectory, filePath, fileName + '.lua')
            with open(filePath, 'r', encoding='utf-8') as f:
                content = f.read()
            content = re.match(r".*" + fileName + r" = (\{.*\})", content, flags = re.DOTALL)[1]
            o = slpp.decode(content)
            for k, v in o.items():
                if isinstance(v, dict) and 'id' in v.keys():
                    output[v['id']] = v
                else:
                    output[k] = v
            if isinstance(output, dict) and 'all' in output.keys():
                del output['all']
        elif mode == 1:
            filePath = os.path.join(DataDirectory, filePath)
            templateFileNames = os.listdir(filePath)
            for fNames in templateFileNames:
                with open(os.path.join(filePath, fNames), 'r', encoding='utf-8') as f:
                    content = f.read()
                content = re.match(r".*" + fileName + r"_\d+ = (\{.*\})", content, flags = re.DOTALL)[1]
                o = slpp.decode(content)
                for k, v in o.items():
                    if isinstance(v, dict) and 'id' in v.keys():
                        output[v['id']] = v
                    else:
                        output[k] = v
            if isinstance(output, dict) and 'all' in output.keys():
                del output['all']
        elif mode == 2:
            filePath = os.path.join(DataDirectory, r'sharecfgdata', fileName + '.serpent')
            with open(filePath, 'r', encoding='utf-8') as f:
                content = f.read()
            content = re.match(r".*" + fileName + r" = (\{.*\})", content, flags = re.DOTALL)[1]
            o = slpp.decode(content)
            for k, v in o.items():
                if isinstance(v, dict) and 'id' in v.keys():
                    output[v['id']] = v
                else:
                    output[k] = v
            if isinstance(output, dict) and 'all' in output.keys():
                del output['all']
        saveJsonFile(output, fileName)
        return output

def getChapterTemplate(fileName = 'chapter_template', filePath = r'sharecfg'):
    if hasJsonFile(fileName):
        return loadJsonFile(fileName)
    else:
        output = {}
        filePath = os.path.join(DataDirectory, filePath, fileName + '.lua')
        with open(filePath, 'r', encoding='utf-8') as f:
            content = f.read()
        results = re.findall(r'uv0\.chapter_template\[.*?\] = (\{.*?\n\t\})', content, flags = re.DOTALL)
        for c in results:
            o = slpp.decode(c)
            output[o['id']] = o
        saveJsonFile(output, fileName)
        return output

def getShipName(skinID, skinTemplate, groupID = None):
    if not groupID:
        groupID = skinTemplate[skinID]['ship_group']
    for k, v in skinTemplate.items():
        if groupID == v['ship_group'] and v['group_index'] == 0:
            return v['name']
    return skinTemplate[skinID]['name']

def getShipType(shipID, shipTemplate, groupID = None):
    if not groupID:
        groupID = shipTemplate[shipID]['group_type']
    for k, v in shipTemplate.items():
        if groupID == v['group_type']:
            return v['type']
    return shipTemplate[shipID]['type']
    
def parseNameCode(text, nameCode, AF = False):
    def parsefunc(matchobj, nameCode = nameCode, AF = AF):
        id = int(matchobj.group(1))
        if id in nameCode.keys():
            if AF:
                return '{{AF|' + nameCode[id] + '}}'
            else:
                return nameCode[id]
        else:
            return matchobj.group(0)
    return re.sub(r'\{namecode\:(\d+)\}', parsefunc, text)
    
def getNameCode():
    content = parseDataFile('name_code')
    if isinstance(content, dict):
        content = content.values()
    output = {}
    for i in content:
        output[i['id']] = i['name']
    return output
        
if __name__ == "__main__":
    pass

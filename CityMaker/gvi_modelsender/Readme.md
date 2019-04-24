# 同步插件说明

## 数据结构

header + report + data 
	- header: 16-bits
		commandCode(4-bit)
		reportSize(4-bit)
		预留(8-bit)

	- report: JSON
		{
			rootID:		guid
			offsetX:	double
			offsetY:	double
			offsetZ:	double
			parentID: guid
			group:	
			{
				gID: guid
				gName: string
				gMat:	[]
			}
			layerID:	ID-int
			mesh: size-int
			files: 
			{
				'tName.jpg': size-int
				...
			}
		}

	- data: mesh(osgString) + files[]

## 指令

0 - 空、无操作
1 - 创建、增加
2 - 编辑、修改
3 - 删除

Sketchup.active_model.definitions



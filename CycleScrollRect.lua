---@class CycleScrollRect
CycleScrollRect = class("CycleScrollRect")
--将 item 作为content的子物体，设置好位置和大小即可
--onUpdataItem 每个item克隆出来后的回调 带参数 itemObj，index
--onEnd 拉到底部时的回调
--构造函数
function CycleScrollRect:ctor(scrollRect, maxNum, onUpdataItem,onEnd)
    ---@type UnityEngine.UI.ScrollRect
    self.sc = scrollRect
    self.gameObject = self.sc.gameObject
    self.transform = self.gameObject.transform
    self.rt=self.gameObject:GetComponent("RectTransform")
    if self.sc.content.childCount==0 then
        print("content下的item不能为空")
        return
    end
    ---@type UnityEngine.RectTransform[]
    self.itemRTLs = {}
    ---@type UnityEngine.RectTransform
    self.view = self.sc.viewport
    ---@type UnityEngine.GameObject
    self.item = self.sc.content:GetChild(0).gameObject
    ---@type UnityEngine.RectTransform
    self.itemRT = self.item:GetComponent("RectTransform")
    self.item:SetActive(false)
    self.maxNum = maxNum
    self.numberOfColumns=nil
    self.numberOfLines=nil
    self.columnOfPage=nil
    self.lineOfPage=nil

    self.sc.content:SetInsetAndSizeFromParentEdge(UnityEngine.RectTransform.Edge.Left,0,0)
    self.sc.content.pivot=Vector2.New(0,1)
    self.itemRT.anchorMax=Vector2.New(0,1)--固定好位置，方便计算
    self.itemRT.anchorMin=Vector2.New(0,1)--固定好位置，方便计算
    self.itemRT.anchoredPosition=Vector2.New(0,0)
    self.itemRT.pivot=Vector2.New(0,1)
    self:initColAndLine()
    self.sc.content.sizeDelta = Vector2.New(self.itemRT.rect.width*self.numberOfColumns, self.itemRT.rect.height * self.numberOfLines)


    self.onUpdataItem = onUpdataItem
    self.onEnd=onEnd
    for i = 1, self.lineOfPage*self.columnOfPage do
        self:creatItem()
    end
    self.sc.onValueChanged:AddListener(function()
        self:updataShow()
    end)
    self.gameObject:AddComponent(typeof(AWLuaBehaviour)):RegisterDestroy(function()
        self.sc.onValueChanged:RemoveAllListeners()
        self.sc = nil
        self.onUpdataItem=nil
        self.onEnd=nil
        self.itemRTLs = nil
        self = nil
    end)
end

--创建item
--isforward 前一页
function CycleScrollRect:creatItem(isforward)
    isforward = isforward or false
    ---@type UnityEngine.RectTransform
    local rt, item
    if #self.itemRTLs < self.columnOfPage * self.lineOfPage then
        item = UnityEngine.GameObject.Instantiate(self.item, self.sc.content)
        item:SetActive(true)
        local curIndex=#self.itemRTLs+1
        item.name = curIndex
        rt=item:GetComponent("RectTransform")
        table.insert(self.itemRTLs, rt)
    else
        if isforward then
            rt = table.remove(self.itemRTLs, #self.itemRTLs)
            rt.gameObject.name = rt.gameObject.name - self.lineOfPage*self.columnOfPage
            table.insert(self.itemRTLs, 1, rt)
        else
            rt = table.remove(self.itemRTLs, 1)
            rt.gameObject.name = rt.gameObject.name + self.lineOfPage*self.columnOfPage
            table.insert(self.itemRTLs, rt)
        end
    end
    rt.anchoredPosition = self:getPs(tonumber(rt.gameObject.name))
    if self.onUpdataItem ~= nil then
        self.onUpdataItem(rt.gameObject, tonumber(rt.gameObject.name))
    end
end

--更新显示
function CycleScrollRect:updataShow()

end

--初始化行列
function CycleScrollRect:initColAndLine()

end

--计算位置
function CycleScrollRect:getPs(index)

end

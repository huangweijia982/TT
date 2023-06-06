---@class VerticalCycleScrollRect
VerticalCycleScrollRect = class("VerticalCycleScrollRect",CycleScrollRect)



--更新显示
function VerticalCycleScrollRect:updataShow()
    for i = 1, #self.itemRTLs do
        local ps = self.itemRTLs[i]:InverseTransformPoint(self.rt.anchoredPosition)
        --print(self.itemRTLs[i].anchoredPosition)
        if -ps.y-self.itemRT.rect.height > self.view.localPosition.y then
            --print("向上或者左拉")
            if self.itemRTLs[#self.itemRTLs].gameObject.name == tostring(self.maxNum) then
                --print("到底了")
                return
            end
            self:creatItem(false)
            break
        end
        if -ps.y+self.itemRT.rect.height < self.view.localPosition.y-self.view.rect.height then
            --print("向下或者右拉")
            if self.itemRTLs[1].gameObject.name=="1" then
                --print("到底了")
                if self.onEnd~=nil then
                    self.onEnd()
                end
                return
            end
            self:creatItem(true)
            break
        end
    end
end

--初始化行列
function VerticalCycleScrollRect:initColAndLine()
    self.numberOfColumns= math.floor(self.sc.viewport.rect.width/self.itemRT.rect.width)--总列数
    self.numberOfLines=math.ceil(self.maxNum/self.numberOfColumns)--总行数
    self.columnOfPage= self.numberOfColumns--一页的列数
    self.lineOfPage=math.ceil(self.sc.viewport.rect.height/self.itemRT.rect.height)+2--一页的行数，多二个作为缓冲，也就是实际克隆出来的item个数
end

--计算位置
function VerticalCycleScrollRect:getPs(index)
    local value=index%self.numberOfColumns
    local cum_x = value==0 and self.numberOfColumns or value
    local cum_y = math.ceil(index/self.numberOfColumns)
    return Vector2.New(self.itemRT.anchoredPosition.x+self.itemRT.rect.width * (cum_x-1), self.itemRT.anchoredPosition.y-self.itemRT.rect.height * (cum_y-1))
end

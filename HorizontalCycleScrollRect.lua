---@class HorizontalCycleScrollRect
HorizontalCycleScrollRect = class("HorizontalCycleScrollRect",CycleScrollRect)

--更新显示
function HorizontalCycleScrollRect:updataShow()
    for i = 1, #self.itemRTLs do
        local ps = self.itemRTLs[i]:InverseTransformPoint(self.rt.anchoredPosition)
        --print(self.itemRTLs[i].anchoredPosition)
        if -ps.x-self.itemRT.rect.width > self.view.localPosition.x then
            --print("向上或者左拉")
            if self.itemRTLs[#self.itemRTLs].gameObject.name == tostring(self.maxNum) then
                --print("到底了")
                return
            end
            self:creatItem(false)
            break
        end
        if -ps.x+self.itemRT.rect.width < self.view.localPosition.x-self.view.rect.width then
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
function HorizontalCycleScrollRect:initColAndLine()
    self.numberOfLines= math.floor(self.sc.viewport.rect.height/self.itemRT.rect.height)--总行数
    self.numberOfColumns= math.ceil(self.maxNum/self.numberOfLines)--总列数
    self.columnOfPage=math.ceil(self.sc.viewport.rect.width/self.itemRT.rect.width)+2 --一页的列数，多二个作为缓冲，也就是实际克隆出来的item个数
    self.lineOfPage=self.numberOfLines --一页的行数
end

--计算位置
function HorizontalCycleScrollRect:getPs(index)
    local value=index%self.numberOfLines
    local cum_y = value==0 and self.numberOfLines or value
    local cum_x = math.ceil(index/self.numberOfLines)
    return Vector2.New(self.itemRT.anchoredPosition.x+self.itemRT.rect.width * (cum_x-1), self.itemRT.anchoredPosition.y-self.itemRT.rect.height * (cum_y-1))
end

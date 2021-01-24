module SubTag
  extend ActiveSupport::Concern

  included do
    
  end

  module ClassMethods
  end

  def set_subtag(params)

    case params[:category_list]
    when "電玩"
      self.sub_list =  "主機遊戲, 掌上型電玩, 桌遊, 電腦遊戲"
    when "書本"
      self.sub_list =  "程式, 漫畫, 小說, 參考書"
    when "衣服"
      self.sub_list =  "男裝, 女裝, 童裝, Cos"
    when "其他"
      self.sub_list =  "暫定, 暫定, 暫定, 暫定"
    end

    self.sub_list
  end

end
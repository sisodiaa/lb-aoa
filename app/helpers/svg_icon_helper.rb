module SvgIconHelper
  def svg_icon(file_name, element)
    tag.use href: "#{asset_path(file_name)}##{element}"
  end
end

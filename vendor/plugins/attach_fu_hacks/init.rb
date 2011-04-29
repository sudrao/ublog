Technoweenie::AttachmentFu::Backends::DbFileBackend.module_eval do
  def image_data(thumb_flag = false)
    # if thumb desired and thumbnails.first exists
    if thumb_flag && (the_thumb = thumbnails.first)
      the_thumb.current_data
    else
      current_data
    end
  end
end

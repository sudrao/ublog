xml.page do
    xml.title("ublog JSON")
    xml.link(my_base_url + home_path(@home))
    xml.ublog_id(@home.ublog_name)
    xml.description("#{@home.name}'s ublog page")
    home_id = @home.id
    xml.content do
    for blog in @blogs
      origin = blog.origin
      next unless origin
      asset = origin.asset
      attach = blog.attachment
      xml.ublogMessages do
        xml.ublogSenderName(origin.ublog_name)
        xml.ublogSenderUrl(my_base_url + home_path(origin))
        xml.ublogSenderImageName(asset.db_file_id) if asset
        xml.ublogSenderImageUrl(my_base_url + 
	  asset_type_path(asset, true)) if asset
        if (blog.to)
          xml.ublogToName('@' + blog.to.ublog_name)
          xml.ublogToUrl(my_base_url + home_path(blog.to))
          previous_text = blog.previous
          xml.ublogPreviousText(previous_text ) if previous_text
        end
        xml.ublogText(blog.webify(my_base_url, true))
        xml.ublogWhen(blog_when(blog))
        if attach
          if attach.is_image
            xml.ublogImageAttachmentName(attach.filename)
            xml.ublogImageAttachmentUrl(my_base_url + attach.public_filename)
            xml.ublogImageAttachmentThumb(my_base_url + 
	      attach.public_filename(:thumb))
          else
            xml.ublogAttachmentUrl(my_base_url + attach.public_filename)
          end
        end
      end
    end
    end
end


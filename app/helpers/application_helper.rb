module ApplicationHelper

  def link_to_sortable(column, title=nil)
    title ||= column.titleize

    our_params = params.dup
    our_params[:direction] = (params[:direction] == 'asc' ? 'desc' : 'asc')
    css_class = column == params[:sort] ? "sortable current #{our_params[:direction]}" : "sortable"
    our_params[:sort] = column

    link_to title, our_params, {:class => css_class}
  end

  def params_without(*args)
    mod_params = params.dup
    args.each do |arg|
      mod_params[arg.to_sym] = nil
    end
    mod_params
  end

end

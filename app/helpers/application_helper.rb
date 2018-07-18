module ApplicationHelper
  include ApplicationPermissions

  def navbar_class(name)
    if navbar_active?(name)
      'active'
    else
      ''
    end
  end

  def navbar_active?(name)
    case name
    when :home
      controller_name == 'pages' && action_name == 'home'
    when :admin
      controller.is_a? AdminController
    else
      controller_path.start_with? name.to_s
    end
  end

  def format_options
    Format.all.collect { |format| [format.name, format.id] }
  end

  def divisions_select
    @league.divisions.all.collect { |div| [div.name, div.id] }
  end

  def bootstrap_paginate(target)
    will_paginate target, renderer: BootstrapPagination::Rails
  end

  def present(object, klass = nil)
    klass ||= BasePresenter.presenter object

    klass.new(object, self)
  end

  def present_collection(collection, klass = nil)
    collection.map { |object| present(object, klass) }
  end
  
  def git_revision
    if File.exists?(File.join(Rails.root, "REVISION"))
      File.open(File.join(Rails.root, "REVISION"), 'r') { |f| return f.gets.chomp }
    else
      `SHA1=$(git rev-parse HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
    end
  end
  
  # painful workaround to `true_user` not being available in rspec tests
  def true_user
    @impersonated_user || current_user
  end  
  
  
end

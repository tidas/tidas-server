TidasBackend::App.controllers :downloads do

  before {authorize!}

  get :libtidas do
    send_file("downloads/libtidas/libtidas_1_0_0.zip")
  end

  get :xcode_project do
    send_file("downloads/xcode_project/xcode_project_1_0_0.zip")
  end

end
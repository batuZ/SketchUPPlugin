module GVI_Modelsender


class GVIViewObserver < Sketchup::ViewObserver
    def onViewChanged(view)
        msg = "cam:#{view.camera.eye.to_a + view.camera.target.to_a}"
        # sendMessage(msg)
        puts msg
    end
end

end
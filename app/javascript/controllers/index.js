// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CmsEditorController from "./cms_editor_controller.js"
application.register("cms-editor", CmsEditorController)

import Dashboard__ComponentController from "./dashboard/component_controller.js"
application.register("dashboard--component", Dashboard__ComponentController)

import Dashboard__ListController from "./dashboard/list_controller.js"
application.register("dashboard--list", Dashboard__ListController)

import Flowbite__CollapseController from "./flowbite/collapse_controller.js"
application.register("flowbite--collapse", Flowbite__CollapseController)

import Flowbite__DropdownController from "./flowbite/dropdown_controller.js"
application.register("flowbite--dropdown", Flowbite__DropdownController)

import HelloController from "./hello_controller.js"
application.register("hello", HelloController)

import ResetFormController from "./reset_form_controller.js"
application.register("reset-form", ResetFormController)

import Search__Post__ModalController from "./search/post/modal_controller.js"
application.register("search--post--modal", Search__Post__ModalController)

import Search__Post__SelectOptionController from "./search/post/select_option_controller.js"
application.register("search--post--select-option", Search__Post__SelectOptionController)

import ToastController from "./toast_controller.js"
application.register("toast", ToastController)

namespace RepositoriesManager {
public class EditRepository : Gtk.Dialog {
  
    private ConfigFileReader configFileReader = new ConfigFileReader ();
    private CommandHandler commandHandler = new CommandHandler();
    ListManager listManager = ListManager.get_instance();
    Gtk.Entry aptEntry;
    string oldRepository;

    public EditRepository(string repository){
        oldRepository = repository;

        if(repository == ""){
            new Alert("No repository was selected", "Please select a repository and try again.");  
            return;      
        }

        title = "Enter the complete APT line of the repository that you want to add as source.";
        var description = "The APT line includes the type, location and components of a repository, for example  'deb http://archive.ubuntu.com/ubuntu xenial main'.";
        set_default_size (630, 430);
        resizable = false;
 
        var image = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;

        var aptLabel = new Gtk.Label ("apt:");
        aptEntry = new Gtk.Entry ();
        aptEntry.set_placeholder_text (repository);
        aptEntry.set_text (repository);
        aptEntry.set_tooltip_text ("This is the link to the repository.");

        var primary_label = new Gtk.Label ("<b>%s</b>".printf (title));
        primary_label.use_markup = true;
        primary_label.selectable = true;
        primary_label.max_width_chars = 50;
        primary_label.wrap = true;
        primary_label.xalign = 0;

        var secondary_label = new Gtk.Label (description);
        secondary_label.use_markup = true;
        secondary_label.selectable = true;
        secondary_label.max_width_chars = 50;
        secondary_label.wrap = true;
        secondary_label.xalign = 0;

        var message_grid = new Gtk.Grid ();
        message_grid.column_spacing = 12;
        message_grid.row_spacing = 6;
        message_grid.margin_end = 12;
        message_grid.attach (image, 0, 0, 1, 2);
        message_grid.attach (primary_label, 1, 0, 1, 1);
        message_grid.attach (secondary_label, 1, 1, 1, 1);
        message_grid.attach (aptLabel, 0, 2, 1, 1);
        message_grid.attach (aptEntry, 1, 2, 1, 1);
        message_grid.show_all ();

        get_content_area ().add (message_grid);

        resizable = false;
        deletable =  false;
        skip_taskbar_hint = true;
        transient_for = null;
        
        var close_button = new Gtk.Button.with_label ("Close");
        close_button.margin_right = 12;
        close_button.clicked.connect (() => {
            this.destroy ();
        });

        var create_button = new Gtk.Button.with_label ("Edit");
        create_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);        
        create_button.clicked.connect (() => {
            editCurrentRepository();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_start (close_button);
        button_box.pack_end (create_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        get_content_area ().add (button_box);
        this.show_all ();
    }

    public void editCurrentRepository(){
        var repositories = configFileReader.getRepositories();

        if(isNotValid(aptEntry.text)){
            new Alert("Field is invalid", "The APT line includes the type, location and components of a repository, for example  'deb http://archive.ubuntu.com/ubuntu xenial main'.");
            return;
        }

        commandHandler.editRepo(oldRepository, aptEntry.text);
        listManager.getList().getRepositories("");    
        this.destroy ();
    }

    public bool isNotValid(string inputField){
        if(inputField ==  ""){
            return true;
        }

        if(!("deb" in inputField) && !("deb-src" in inputField)){ 
            return true;
        }
        return false;
    }
}
}

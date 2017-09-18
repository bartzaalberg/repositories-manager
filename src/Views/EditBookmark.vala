namespace BookmarkManager {
public class EditBookmark : Gtk.Grid{
 
    StackManager stackManager = StackManager.get_instance();
    BookmarkListManager bookmarkListManager = BookmarkListManager.get_instance();

    private Gtk.Entry hostEntry = new Gtk.Entry ();
    private Gtk.Entry hostNameEntry = new Gtk.Entry ();
    private Gtk.Entry userNameEntry = new Gtk.Entry ();
    private Gtk.Entry portEntry = new Gtk.Entry ();
    private Gtk.CheckButton agentForwardCheckButton = new Gtk.CheckButton();
    private Gtk.Entry proxyCommandEntry = new Gtk.Entry ();

    public EditBookmark(){ 
        var general_header = new HeaderLabel ("Edit a bookmark");
       
        var hostLabel = new Gtk.Label ("Host:*");
        hostLabel.set_alignment(0,0);

        var hostNameLabel = new Gtk.Label ("Host name:*");
        hostNameLabel.set_alignment(0,0);

        var userNameLabel = new Gtk.Label ("Username:");
        userNameLabel.set_alignment(0,0);
        
        var portLabel = new Gtk.Label ("Port:");
        portLabel.set_alignment(0,0);

        var agentForwardLabel = new Gtk.Label ("Use agent forwarding:");
        agentForwardLabel.set_alignment(0,0);
        
        var proxyCommandLabel = new Gtk.Label ("Proxy command:");
        proxyCommandLabel.set_alignment(0,0);

        hostEntry.set_placeholder_text("server1");
        hostEntry.set_sensitive(false);
        hostNameEntry.set_placeholder_text("127.0.0.1");
        userNameEntry.set_placeholder_text("james");
        portEntry.set_placeholder_text("80");
        proxyCommandEntry.set_placeholder_text("ssh bookmark nc %h %p");
        
        var back_button = new Gtk.Button.with_label ("Back");
        back_button.clicked.connect (() => {
            stackManager.getStack().visible_child_name = "list-view";
            bookmarkListManager.getList().getRepositories("");
        });

        var edit_button = new Gtk.Button.with_label ("Edit");
        edit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        edit_button.clicked.connect (() => {
           EditBookmarkInFile();
        });

        var button_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        button_box.set_layout (Gtk.ButtonBoxStyle.END);
        button_box.pack_end (back_button);
        button_box.pack_end (edit_button);
        button_box.margin = 12;
        button_box.margin_bottom = 0;

        this.row_spacing = 12;
        this.column_spacing = 12;
        this.margin = 12;
        this.attach (general_header, 0, 0, 2, 1);
        this.attach (hostLabel, 0, 1, 1, 1);
        this.attach (hostEntry, 1, 1, 1, 1);
        this.attach (hostNameLabel, 0, 2, 1, 1);
        this.attach (hostNameEntry, 1, 2, 1, 1);
        this.attach (userNameLabel, 0, 3, 1, 1);
        this.attach (userNameEntry, 1, 3, 1, 1);
        this.attach (portLabel, 0, 4, 1, 1);
        this.attach (portEntry, 1, 4, 1, 1);
        this.attach (agentForwardLabel, 0, 5, 1, 1);
        this.attach (agentForwardCheckButton, 1, 5, 1, 1);
        this.attach (proxyCommandLabel, 0, 6, 1, 1);
        this.attach (proxyCommandEntry, 1, 6, 1, 1);

        this.attach (button_box, 1, 7, 1, 1);
        
    }

    public void loadBookmark(Bookmark bookmark){
       
        
        hostEntry.text = "";
        hostNameEntry.text = "";
        portEntry.text = "";
        userNameEntry.text = "";
        agentForwardCheckButton.active = false;
        proxyCommandEntry.text = "";
        

        if(bookmark.getName() != null){
            hostEntry.text = bookmark.getName();
        }
        if(bookmark.getIp() != null){ 
            hostNameEntry.text = bookmark.getIp();
        }

        if(bookmark.getPort() != 0){ 
            portEntry.text = bookmark.getPort().to_string();  
        }

        if(bookmark.getUser() != null){ 
            userNameEntry.text = bookmark.getUser();
        }

        if(bookmark.getForwardAgent() != null){ 
            agentForwardCheckButton.active = true;
        }

        if(bookmark.getProxyCommand() != null){ 
            proxyCommandEntry.text = bookmark.getProxyCommand();
        }
        
    }

    public void EditBookmarkInFile(){
        
        string editedRepository = hostEntry.text;
        
        if(isNotValid(editedRepository)){
            new Alert("Fields are invalid", "Please correctly fill in all the required fields");
            return;
        }

        var ConfigFileReader = new ConfigFileReader(); 
        var repositories = ConfigFileReader.getRepositories(); 

        var i = 0;

        foreach (string repository in repositories) {
            if(repository == editedRepository) {
                break;
            }
            i++;
        }

        ConfigFileReader.writeToFile(repositories);

        stackManager.getStack().visible_child_name = "list-view";
        bookmarkListManager.getList().getRepositories("");    
    }

    public bool isNotValid(string editedRepository){
        if(editedRepository == ""){
            return true;
        }
        return false;
    }
}
}

namespace BookmarkManager {
public class StackManager : Object {
    
    static StackManager? instance;

    private Gtk.Stack stack;
    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string ADD_BOOKMARK_VIEW_ID = "add-bookmark-view";
    private const string LIST_VIEW_ID = "list-view";
    private const string EMPTY_VIEW_ID = "empty-view";
    private const string NOT_FOUND_VIEW_ID = "not-found-view";
    private const string EDIT_BOOKMARK_VIEW_ID = "edit-bookmark-view";

    EditBookmark editBookmarkPage;

    // Private constructor
    StackManager() {
        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }
 
    // Public constructor
    public static StackManager get_instance() {
        if (instance == null) {
            instance = new StackManager();
        }
        return instance;
    }

    public Gtk.Stack getStack() {
        return this.stack;
    }

    public void loadViews(Gtk.Window window){
        editBookmarkPage = new EditBookmark();

        stack.add_named (new EmptyView(), EMPTY_VIEW_ID);
        stack.add_named (new ListBookmarks(), LIST_VIEW_ID);
        stack.add_named (new AddBookmark(), ADD_BOOKMARK_VIEW_ID);
        stack.add_named (new WelcomeView(), WELCOME_VIEW_ID);
        stack.add_named (new NotFoundView(), NOT_FOUND_VIEW_ID);
        stack.add_named (editBookmarkPage, EDIT_BOOKMARK_VIEW_ID);

        window.add(stack);
        window.show_all();
   }

    public void setEditBookmark(Bookmark bookmark){
        editBookmarkPage.loadBookmark(bookmark);
    }
}
}

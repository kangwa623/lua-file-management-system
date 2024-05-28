import tkinter as tk
from tkinter import messagebox, filedialog

# Dictionary of file extensions organized by type
file_extensions = {
    "Textual Files": [
        (".txt", "Plain Text File"),
        (".md", "Markdown Text File"),
        (".csv", "Comma-Separated Values File"),
        (".json", "JavaScript Object Notation File"),
        (".xml", "Extensible Markup Language File"),
        (".log", "Log File"),
    ],
    "Audio Files": [
        (".mp3", "MPEG Layer 3 Audio"),
        (".wav", "Waveform Audio File"),
        (".aac", "Advanced Audio Coding File"),
        (".flac", "Free Lossless Audio Codec"),
        (".ogg", "Ogg Vorbis Audio File"),
        (".m4a", "MPEG-4 Audio"),
    ],
    "Video Files": [
        (".mp4", "MPEG-4 Video File"),
        (".avi", "Audio Video Interleave File"),
        (".mkv", "Matroska Video File"),
        (".mov", "Apple QuickTime Movie"),
        (".wmv", "Windows Media Video File"),
        (".flv", "Flash Video File"),
    ],
    "Image Files": [
        (".jpg", "JPEG Image"),
        (".jpeg", "JPEG Image"),
        (".png", "Portable Network Graphic"),
        (".gif", "Graphics Interchange Format File"),
        (".bmp", "Bitmap Image File"),
        (".tiff", "Tagged Image File Format"),
        (".tif", "Tagged Image File Format"),
        (".svg", "Scalable Vector Graphics File"),
    ],
    "Document Files": [
        (".pdf", "Portable Document Format"),
        (".doc", "Microsoft Word Document"),
        (".docx", "Microsoft Word Document"),
        (".xls", "Microsoft Excel Spreadsheet"),
        (".xlsx", "Microsoft Excel Spreadsheet"),
        (".ppt", "Microsoft PowerPoint Presentation"),
        (".pptx", "Microsoft PowerPoint Presentation"),
        (".odt", "OpenDocument Text Document"),
        (".rtf", "Rich Text Format"),
    ],
    "Compressed Files": [
        (".zip", "ZIP Archive"),
        (".rar", "RAR Archive"),
        (".tar", "Tarball File"),
        (".gz", "Gzip Compressed File"),
        (".7z", "7-Zip Archive"),
    ],
    "Executable Files": [
        (".exe", "Windows Executable File"),
        (".msi", "Windows Installer Package"),
        (".bat", "Batch File"),
        (".sh", "Shell Script"),
        (".dmg", "macOS Disk Image"),
        (".app", "macOS Application Bundle"),
    ],
    "Other Common File Types": [
        (".html", "HyperText Markup Language File"),
        (".htm", "HyperText Markup Language File"),
        (".css", "Cascading Style Sheets File"),
        (".js", "JavaScript File"),
        (".py", "Python Script"),
        (".java", "Java Source File"),
        (".php", "PHP Script"),
        (".apk", "Android Package"),
        (".iso", "ISO Disc Image"),
    ],
}

def on_submit():
    selected_extensions = [ext for cat, exts in file_extensions.items() for ext, desc in exts if var_dict[ext].get()]
    source_directory = source_directory_var.get()
    destination_directory = destination_directory_var.get()

    if not selected_extensions:
        messagebox.showerror("Error", "No file extensions selected!")
        return

    if not source_directory:
        messagebox.showerror("Error", "No source directory selected!")
        return

    if not destination_directory:
        messagebox.showerror("Error", "No destination directory selected!")
        return

    try:
        # Call the Lua script with the selected extensions and directories
        call_lua_script(source_directory, destination_directory, selected_extensions)
        messagebox.showinfo("Success", "Operation completed successfully!")
        root.quit()
    except Exception as e:
        messagebox.showerror("Error", f"An error occurred: {str(e)}")
    
    # Don't quit the application abruptly
    # root.quit()


def call_lua_script(source_directory, destination_directory, selected_extensions):
    import subprocess
    #  Calling  Lua script  with the selected extensions and directories
    subprocess.call(['lua54', 'ExtensionsOrg.lua', source_directory, destination_directory ] +  selected_extensions)


def toggle_all(category, var, extensions):
    """Toggle all checkbuttons in a category."""
    for ext, _ in extensions:
        var_dict[ext].set(var.get())

def browse_directory(var):
    """Open a dialog to browse for a directory."""
    selected_directory = filedialog.askdirectory()
    if selected_directory:
        var.set(selected_directory)

# Create the main window
root = tk.Tk()
root.title("Select File Extensions")
root.geometry("600x800")
root.configure(bg="#f0f4c3")

# Create a frame for the source directory input and browse button
source_frame = tk.Frame(root, bg="#f0f4c3")
source_frame.pack(fill=tk.X, pady=10)

source_directory_label = tk.Label(source_frame, text="Source Directory:", font=('Arial', 12, 'bold'), bg="#f0f4c3")
source_directory_label.pack(side=tk.LEFT, padx=5)

source_directory_var = tk.StringVar()
source_directory_entry = tk.Entry(source_frame, textvariable=source_directory_var, width=50)
source_directory_entry.pack(side=tk.LEFT, padx=5)

source_browse_button = tk.Button(source_frame, text="Browse", command=lambda: browse_directory(source_directory_var), bg="#8bc34a", fg="white")
source_browse_button.pack(side=tk.LEFT, padx=5)

# Create a frame for the destination directory input and browse button
destination_frame = tk.Frame(root, bg="#f0f4c3")
destination_frame.pack(fill=tk.X, pady=10)

destination_directory_label = tk.Label(destination_frame, text="Destination Directory:", font=('Arial', 12, 'bold'), bg="#f0f4c3")
destination_directory_label.pack(side=tk.LEFT, padx=5)

destination_directory_var = tk.StringVar()
destination_directory_entry = tk.Entry(destination_frame, textvariable=destination_directory_var, width=50)
destination_directory_entry.pack(side=tk.LEFT, padx=5)

destination_browse_button = tk.Button(destination_frame, text="Browse", command=lambda: browse_directory(destination_directory_var), bg="#8bc34a", fg="white")
destination_browse_button.pack(side=tk.LEFT, padx=5)

# Create a frame and a canvas with a scrollbar for the file extensions
frame = tk.Frame(root, bg="#f0f4c3")
frame.pack(fill=tk.BOTH, expand=1, pady=10)

canvas = tk.Canvas(frame, bg="#f0f4c3")
canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=1)

scrollbar = tk.Scrollbar(frame, orient=tk.VERTICAL, command=canvas.yview)
scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

canvas.configure(yscrollcommand=scrollbar.set)
canvas.bind('<Configure>', lambda e: canvas.configure(scrollregion=canvas.bbox("all")))

second_frame = tk.Frame(canvas, bg="#f0f4c3")

canvas.create_window((0,0), window=second_frame, anchor="nw")

# Create a dictionary to store the variables
var_dict = {}

# Create checkbuttons for each file extension organized by type
for category, extensions in file_extensions.items():
    label = tk.Label(second_frame, text=category, font=('Arial', 12, 'bold'), bg="#ffcc80", fg="#000")
    label.pack(anchor='w', pady=5)
    
    select_all_var = tk.BooleanVar()
    select_all_chk = tk.Checkbutton(second_frame, text=f"Select All {category}", variable=select_all_var,
                                    command=lambda cat=category, var=select_all_var, exts=extensions: toggle_all(cat, var, exts),
                                    bg="#f0f4c3", activebackground="#ffcc80")
    select_all_chk.pack(anchor='w', padx=20, pady=2)
    
    for ext, desc in extensions:
        var_dict[ext] = tk.BooleanVar()
        chk = tk.Checkbutton(second_frame, text=f"{ext} - {desc}", variable=var_dict[ext], bg="#f0f4c3", activebackground="#ffcc80")
        chk.pack(anchor='w', padx=40, pady=2)

# Create the submit button
submit_btn = tk.Button(root, text="Submit", command=on_submit, bg="#8bc34a", fg="white", font=('Arial', 12, 'bold'))
submit_btn.pack(pady=20)

# Run the main loop
root.mainloop()

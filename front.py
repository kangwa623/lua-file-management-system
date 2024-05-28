import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image, ImageTk
import subprocess
import threading
import os
import time

class FileOrganizerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("File Management System")
        self.root.geometry("900x600")
        self.root.configure(bg="#f0f0f0")

        # Initialize folder paths
        self.source_folder = None
        self.destination_folder = None
        self.monitor_folder = None

        # Initialize monitoring flag
        self.monitoring_active = False
        self.monitor_thread = None

        # Load images
        try:
            self.logo_img = ImageTk.PhotoImage(Image.open("logo.png").resize((124, 124), Image.LANCZOS))
            self.organize_img = ImageTk.PhotoImage(Image.open("organise.jpeg").resize((50, 50), Image.LANCZOS))
            self.organize2_img = ImageTk.PhotoImage(Image.open("organise2.jpeg").resize((50, 50), Image.LANCZOS))
            self.organize3_img = ImageTk.PhotoImage(Image.open("organise3.jpeg").resize((50, 50), Image.LANCZOS))
        except FileNotFoundError as e:
            print(f"Error: {e}")
            messagebox.showerror("File Not Found", f"Required image file not found: {e.filename}")
            self.root.destroy()  # Close the application if images are missing
            return

        self.create_widgets()

    def create_widgets(self):
        # Header
        header_frame = tk.Frame(self.root, bg="#4B0082", height=100)
        header_frame.pack(fill="x")
        logo_label = tk.Label(header_frame, image=self.logo_img, bg="#4B0082")
        logo_label.pack(side="left", padx=20)
        title_label = tk.Label(header_frame, text="THE FILE MANAGEMENT SYSTEM", fg="#fff", bg="#4B0082", font=("Roboto", 24, "bold"))
        title_label.pack(anchor="e", padx=20)
        subtitle_label = tk.Label(header_frame, text="ORGANIZE YOUR FILES IN A SINGLE CLICK", fg="#DAA520", bg="#4B0082", font=("Roboto", 16))
        subtitle_label.pack(anchor="e", padx=20)
           
               

        # Main
        main_frame = tk.Frame(self.root, bg="#f0f0f0")
        main_frame.pack(expand=True, fill="both")

        button_container = tk.Frame(main_frame, bg="#f0f0f0", bd=0, highlightthickness=0)
        button_container.pack(pady=20)

        # Organize Downloads Button
        organize_button = tk.Button(button_container, image=self.organize_img, text="Organize downloads folder", compound="top",
                                    command=self.handle_organize_click, bg="#f0f0f0", fg="#4B0082", font=("Roboto", 10, "bold"),
                                    borderwidth=3, relief="raised", highlightthickness=2)
        organize_button.grid(row=0, column=0, padx=20, pady=10)
        self.add_hover_effect(organize_button)

        # Specify Directory Button
        specify_button = tk.Button(button_container, image=self.organize2_img, text="Specify directory", compound="top",
                                   command=self.handle_specify_click, bg="#f0f0f0", fg="#4B0082", font=("Roboto", 10, "bold"),
                                   borderwidth=3, relief="raised", highlightthickness=2)
        specify_button.grid(row=0, column=1, padx=20, pady=10)
        self.add_hover_effect(specify_button)

        # Source and Destination Selection
        source_dest_button = tk.Button(button_container, image=self.organize2_img, text="Select Source & Destination", compound="top",
                                       command=self.handle_source_destination_click, bg="#f0f0f0", fg="#4B0082", font=("Roboto", 10, "bold"),
                                       borderwidth=3, relief="raised", highlightthickness=2)
        source_dest_button.grid(row=3, column=0, padx=20, pady=10)
        self.add_hover_effect(source_dest_button)

        start_org_button = tk.Button(button_container, text="Start Organization(from source to destination)", command=self.handle_start_org_click, bg="#4B0082", fg="#fff", font=("Roboto", 10, "bold"),
                                     borderwidth=3, relief="raised", highlightthickness=2)
        start_org_button.grid(row=1, column=1, padx=20, pady=10)

        # File Monitor
        monitor_button = tk.Button(button_container, image=self.organize2_img, text="   Select Folder to Monitor   ", compound="top",
                                   command=self.handle_monitor_click, bg="#f0f0f0", fg="#4B0082", font=("Roboto", 10, "bold"),
                                   borderwidth=3, relief="raised", highlightthickness=2)
        monitor_button.grid(row=2, column=0, padx=20, pady=10)
        self.add_hover_effect(monitor_button)

        start_monitor_button = tk.Button(button_container, text="Activate File Monitor on Folder Specified Now", command=self.handle_start_monitor_click, bg="#4B0082", fg="#fff", font=("Roboto", 10, "bold"),
                                         borderwidth=3, relief="raised", highlightthickness=2)
        start_monitor_button.grid(row=2, column=1, padx=20, pady=10)

        # Disable File Monitor Button
        disable_monitor_button = tk.Button(button_container, text="Disable File Monitor", command=self.handle_disable_monitor_click, bg="#4B0082", fg="#fff", font=("Roboto", 10, "bold"),
                                           borderwidth=3, relief="raised", highlightthickness=2)
        disable_monitor_button.grid(row=3, column=1, padx=20, pady=10)

        self.message_label = tk.Label(main_frame, text="", bg="#f0f0f0", font=("Roboto", 12), bd=0, highlightthickness=0)
        self.message_label.pack(pady=20)

        # Move specific types of files button
        view_button = tk.Button(button_container, image=self.organize3_img, text="   Move specific file types   ", compound="top",
                                command=self.handle_specificType_click, bg="#f0f0f0", fg="#4B0082", font=("Roboto", 10, "bold"),
                                borderwidth=3, relief="raised", highlightthickness=2)
        view_button.grid(row=1, column=0, padx=20)
        self.add_hover_effect(view_button)

    def add_hover_effect(self, button):
        button.bind("<Enter>", lambda e: button.config(bg="#add8e6"))
        button.bind("<Leave>", lambda e: button.config(bg="#f0f0f0"))

    def handle_organize_click(self):
        messagebox.showinfo("Information", "Organizing...")
        try:
            result = subprocess.run(['lua54', 'Organisedownloads.lua'], capture_output=True, text=True)
            if result.returncode == 0:
                messagebox.showinfo("Success", "Downloads folder organized successfully!")
                print(result.stdout)
            else:
                messagebox.showerror("Error", "Failed to organize downloads folder.")
                print(result.stderr)
        except Exception as e:
            messagebox.showerror("Error", "Error occurred while organizing.")
            print(f"Error: {e}")

    def handle_specify_click(self):
        directory = filedialog.askdirectory()
        if directory:
            messagebox.showinfo("Information", f"Selected directory: {directory}")
            self.organize_selected_directory(directory)
        else:
            messagebox.showwarning("Warning", "No directory selected")

    def organize_selected_directory(self, directory):
        try:
            result = subprocess.run(['lua54', 'Specify.lua', directory], capture_output=True, text=True)
            if result.returncode == 0:
                messagebox.showinfo("Success", "Files organized successfully!")
                print(result.stdout)
            else:
                messagebox.showerror("Error", "Failed to organize files.")
                print(result.stderr)
        except Exception as e:
            messagebox.showerror("Error", "Error occurred while organizing files.")
            print(f"Error: {e}")

    def handle_source_destination_click(self):
        self.source_folder = filedialog.askdirectory(title="Select Source Folder")
        self.destination_folder = filedialog.askdirectory(title="Select Destination Folder")
        if self.source_folder and self.destination_folder:
            messagebox.showinfo("Information", f"Source: {self.source_folder}\nDestination: {self.destination_folder}")
        else:
            messagebox.showwarning("Warning", "Please select both source and destination folders")

    def handle_start_org_click(self):
        if self.source_folder and self.destination_folder:
            try:
                result = subprocess.run(['lua54', 'SourceToDestination.lua', self.source_folder, self.destination_folder], capture_output=True, text=True)
                if result.returncode == 0:
                    messagebox.showinfo("Success", "Files organized successfully!")
                    print(result.stdout)
                else:
                    messagebox.showerror("Error", "Failed to organize files.")
                    print(result.stderr)
            except Exception as e:
                messagebox.showerror("Error", "Error occurred while organizing files.")
                print(f"Error: {e}")
        else:
            messagebox.showwarning("Warning", "Please select both source and destination folders")

    def handle_monitor_click(self):
        self.monitor_folder = filedialog.askdirectory(title="Select Folder to Monitor")
        if self.monitor_folder:
            messagebox.showinfo("Information", f"Monitoring folder: {self.monitor_folder}")
        else:
            messagebox.showwarning("Warning", "No folder selected for monitoring")

    def handle_start_monitor_click(self):
        if self.monitor_folder:
            self.monitoring_active = True
            messagebox.showinfo("Information", "Monitoring folder...")
            # Start monitoring in a separate thread
            self.monitor_thread = threading.Thread(target=self.start_monitoring_thread)
            self.monitor_thread.start()
        else:
            messagebox.showwarning("Warning", "Please select a folder to monitor")

    def start_monitoring_thread(self):
        while self.monitoring_active:
            try:
                result = subprocess.run(['lua54', 'Monitor.lua', self.monitor_folder], capture_output=True, text=True, timeout=5)
                if result.returncode == 0:
                    print(result.stdout)
                else:
                    print(result.stderr)
            except subprocess.TimeoutExpired:
                continue  # Continue the loop if the timeout expires
            except Exception as e:
                messagebox.showerror("Error", "Error occurred while starting monitoring.")
                print(f"Error: {e}")
                break

    def handle_disable_monitor_click(self):
        if self.monitoring_active:
            self.monitoring_active = False
            if self.monitor_thread and self.monitor_thread.is_alive():
                self.monitor_thread.join()  # Wait for the thread to finish
            messagebox.showinfo("Information", "File monitor disabled.")
        else:
            messagebox.showwarning("Warning", "No active file monitor to disable.")

    def handle_specificType_click(self):
        result = subprocess.run(['python', 'select_extensions.py'], capture_output=True, text=True)
        if result.returncode == 0:
            self.message_label.config(text="Files moved successfully!")
            print(result.stdout)
        else:
            self.message_label.config(text="Failed to move files.")
            print(result.stderr)

if __name__ == "__main__":
    root = tk.Tk()
    app = FileOrganizerApp(root)
    root.mainloop()

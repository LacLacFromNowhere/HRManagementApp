using System.Collections.Generic;
using System.Windows.Controls;

namespace HRManagementApp.Views
{
    public partial class EmployeesView : UserControl
    {
        public EmployeesView()
        {
            InitializeComponent();

            // Gi? l?p d? li?u
            EmployeeList.ItemsSource = new List<dynamic>
            {
                new { Id = "E001", Name = "Nguyen Van A", Position = "Manager" },
                new { Id = "E002", Name = "Tran Thi B", Position = "Developer" },
                new { Id = "E003", Name = "Le Van C", Position = "Designer" }
            };
        }
    }
}
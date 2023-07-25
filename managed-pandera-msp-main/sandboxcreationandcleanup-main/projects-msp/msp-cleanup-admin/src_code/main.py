from google.cloud import resourcemanager_v3
from datetime import datetime
from google.cloud import billing_v1
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
import os

current_date = datetime.today().replace(hour=0, minute=0, second=0, microsecond=0)

def stop_billing(request):
    client = resourcemanager_v3.ProjectsClient()
    folder_id = "209940772252"
    parent = f"folders/{folder_id}"
    request = resourcemanager_v3.ListProjectsRequest(parent=parent)
    response = client.list_projects(request=request)
    current_date = datetime.today().replace(hour=0, minute=0, second=0, microsecond=0)

    projects = []
    for project in response:
        project_id = project.project_id
        project_name = project.display_name
        create_time = project.create_time.timestamp()
        labels = project.labels if project.labels else {}

        if 'env' in labels and labels['env'] == 'msp-terraform-managed':
            duration = int((current_date.timestamp() - create_time) / (24 * 60 * 60))
            
            projects.append({
                'project_id': project_id,
                'project_name': project_name,
                'create_time': create_time,
                'labels': labels,
                'duration_days': duration
            })
            billing_enabled = is_billing_enabled(project_id)
            if billing_enabled:
                print(f"Billing is enabled for project {project_id}")
                if 30 <= duration < 60:
                    send_email_notification(project_name, duration)
                    disable_billing_for_project(project_id)

                elif duration >= 60:
                    send_email_notification(project_name, duration)
                    delete_project(project_id)
            else:
                print(f"Billing is not enabled for project {project_id}")
        
    print(projects)
    return "ok"



def is_billing_enabled(project_id):
    client = billing_v1.CloudBillingClient()
        
    try:
        billing_info = client.get_project_billing_info(name=f"projects/{project_id}")
        return billing_info.billing_enabled
    except Exception as e:
        print(f"Error: Failed to retrieve billing info for project {project_id}")
        print(e)
        return False




def disable_billing_for_project(project_id):

    client = billing_v1.CloudBillingClient()
    project_name = f"projects/{project_id}"
    billing_enabled = False
    try:
        response = client.update_project_billing_info(
            name=project_name,
            project_billing_info={"billing_enabled": billing_enabled},
        )
        print(f"Billing disabled for project {project_id}")
        print(response)
    except Exception as e:
        print(f"Failed to disable billing for project {project_id}")
        print(e)

    
def delete_project(project_id):
    client = resourcemanager_v3.ProjectsClient()
    project_name = f"projects/{project_id}"
    try:
        response = client.delete_project(name=project_name)
        print(f"Project {project_id} was successfully marked for deletion")
        print(response)
    except Exception as e:
        print(f"Failed to delete project {project_id}")
        print(e)


def sendEmailNotification(project_name, days):
    sendgrid_api_key = os.environ.get('SENDGRID_API_KEY')

    if 30 <= days < 60:
        message = Mail(
            from_email='nagesh.kumarsingh@66degrees.com',
            to_emails='sre-team-all@66degrees.com',
            subject='Billing Disabled',
            html_content=f'<strong>Project {project_name} has now been up for {days} days</strong>'
        )
    elif days > 60:
        message = Mail(
            from_email='nagesh.kumarsingh@66degrees.com',
            to_emails='sre-team-all@66degrees.com',
            subject='Project Deletion',
            html_content=f'<strong>Project {project_name} has now been up for {days} days</strong>'
        )
    try:
        sg = SendGridAPIClient(sendgrid_api_key)
        response = sg.send(message)
        print(response.status_code)
        print(response.body)
        print(response.headers)
    except Exception as e:
        print(e)
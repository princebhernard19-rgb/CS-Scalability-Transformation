import pandas as pd

# Load your (redacted) ticket data
# This script identifies which ticket categories are "Automation Candidates"
def analyze_automation_potential(csv_path):
    df = pd.read_csv(csv_path)
    
    # Calculate volume and average resolution time (ART)
    summary = df.groupby('category').agg({
        'ticket_id': 'count',
        'resolution_minutes': 'mean'
    }).rename(columns={'ticket_id': 'volume', 'resolution_minutes': 'avg_resolution_time'})

    # Logic: High volume + Low resolution time = Prime for AI Automation
    # Because these are usually "quick fixes" like password resets
    summary['automation_score'] = summary['volume'] / summary['avg_resolution_time']
    
    return summary.sort_values(by='automation_score', ascending=False)

# Example output would guide the "Project Tier Zero" focus
print("Top Categories for Q3 Automation:")
# analyze_automation_potential('q2_tickets.csv')

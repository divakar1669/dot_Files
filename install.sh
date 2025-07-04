#!/bin/bash

# Append Git aliases and functions to ~/.bashrc
cat << 'EOF' >> ~/.bashrc


# Git Aliases
alias gp='git push'
alias gpull='git pull'
alias ga='git add -A'
alias gs='git status'
alias glo='git log --oneline'
alias gl='git log'
alias gb='git branch'
alias gst='git stash'
alias gcp='git cherry-pick'
alias gr='git reset'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias gclean='git clean -fd'
alias gfetch='git fetch --all --prune'
alias gbl='git blame'

alias glg='git log --graph --oneline --decorate --all'
alias glp='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias glf='git log --follow'
alias gls='git log --stat'
alias gln='git log --name-status'
alias glc='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short --numstat'



# Git Commit Function
function gc() {
    git commit -m "$*"
}



# Merge current branch with a given branch (default: main)
function gmerge() {
    target_branch="${1:-main}"
    current_branch=$(git branch --show-current)
    if [ "$current_branch" == "$target_branch" ]; then
        echo "You are already on '$target_branch' branch."
        return 1
    fi
    echo "Switching to $target_branch branch..."
    git switch "$target_branch" || { echo "Failed to switch to $target_branch branch."; return 1; }
    echo "Pulling latest changes from $target_branch..."
    git pull origin "$target_branch" || { echo "Failed to pull latest changes."; return 1; }
    echo "Switching back to $current_branch..."
    git switch "$current_branch" || { echo "Failed to switch back to $current_branch."; return 1; }
    echo "Merging $target_branch into $current_branch..."
    git merge "$target_branch"
}


# Git Switch Function
function gsw() {
    local branch_name="$1"
    if [ -z "$branch_name" ]; then
        echo "Usage: gsw branch-name"
        return 1
    fi

    # Directly use 'main' as is
    if [ "$branch_name" == "main" ]; then
        full_branch_name="main"
    else
        # If the branch name already starts with "user/divakart/", use it as is
        if [[ "$branch_name" == user/divakart/* ]]; then
            full_branch_name="$branch_name"
        else
            full_branch_name="user/divakart/$branch_name"
        fi
    fi

    echo "Attempting to switch to branch: $full_branch_name"

    # Switch to the branch
    git switch "$full_branch_name"
    switch_status=$?

    if [[ $switch_status -ne 0 ]]; then
        echo "Failed to switch to branch '$full_branch_name'. Git switch command exited with status $switch_status."
        return $switch_status
    else
        echo "Successfully switched to branch '$full_branch_name'."
    fi

    echo "Current branch after switching:"
    git branch --show-current
}


# Git Checkout Branch Function
function gcb() {
    local branch_name="$1"
    if [ -z "$branch_name" ]; then
        echo "Usage: gcb branch-name"
        return 1
    fi

    # Handle wildcard '*' in branch name
    if [[ "$branch_name" == *\** ]]; then
        echo "Branch name cannot contain '*' wildcard."
        return 1
    fi

    # Check if branch name already contains 'user/divakart/' prefix
    if [[ "$branch_name" != user/divakart/* ]]; then
        branch_name="user/divakart/$branch_name"
    fi

    echo "Creating and switching to branch: $branch_name"

    # Create and switch to the new branch
    git checkout -b "$branch_name"
    local checkout_status=$?

    if [[ $checkout_status -ne 0 ]]; then
        echo "Failed to create and switch to branch '$branch_name'. Git checkout command exited with status $checkout_status."
        return $checkout_status
    else
        echo "Successfully switched to a new branch '$branch_name'."
    fi

    echo "Current branch after switching:"
    git branch --show-current
}


# Yarn Aliases
alias yb='yarn build'
alias ypre='yarn prettier --write "./"'

# function ycom() {
#     echo "# Run yarn build"
#     yb
#     echo "# Run yarn prettier"
#     ypre
#     echo "# Check git status"
#     gs
#     echo "# Add changes to staging"
#     ga
#     echo "# Commit changes with a default message"
#     gs
#     echo "# Changes after staging"
#     gc "yarn build committed changes"
    
#     # Prompt the user for input
#     read -p "Do you want to push the changes to the remote repository? (y/n): " push_response

#     # Push to remote if the user confirms
#     if [[ $push_response == "y" || $push_response == "Y" ]]; then
#         echo "# Pushing to remote repository"
#         gp
#     else
#         echo "# Push aborted by the user"
#     fi
# }

function ycom() {
    # Use provided commit message or default if none is given
    commit_message="${1:-"yarn build committed changes"}"

    echo "# Run yarn build"
    yb
    echo "# Run yarn prettier"
    ypre
    echo "# Check git status"
    gs
    echo "# Add changes to staging"
    ga
    
    # Commit changes with the provided or default message
    gc "$commit_message"
    
    # Prompt the user for input to push the changes
    read -p "Do you want to push the changes to the remote repository? (y/n): " push_response

    # Push to remote if the user confirms
    if [[ $push_response == "y" || $push_response == "Y" ]]; then
        echo "# Pushing to remote repository"
        gp
    else
        echo "# Push aborted by the user"
    fi
}


EOF

# Apply changes to the current shell session
source ~/.bashrc

echo "Diva Custom Modifications ... \n Git and Yarn aliases and functions have been added to ~/.bashrc and applied to the current session."
